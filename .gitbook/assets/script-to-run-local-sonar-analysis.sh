#!/bin/bash

# =============================================================================
# SONARQUBE ANALYSIS SCRIPT
# =============================================================================
# This script sets up SonarQube locally and runs Maven analysis
# Usage: ./script-to-run-local-sonar-analysis.sh [project-path] [--skip-tests] [--clean|--stop|--restart]
#
# Examples:
#   ./script-to-run-local-sonar-analysis.sh /path/to/project                                   # Uses project at specified path with tests
#   ./script-to-run-local-sonar-analysis.sh /path/to/project --skip-tests                      # Skip tests for projects with compilation issues
#   ./script-to-run-local-sonar-analysis.sh --clean                                            # Complete reset - removes all containers and data
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SONARQUBE_VERSION="25.9.0.112764-community"
SONARQUBE_PORT="9000"
SONARQUBE_CONTAINER_NAME="local-sonarqube"
POSTGRES_CONTAINER_NAME="local-sonarqube-postgres"
SONARQUBE_URL="http://localhost:${SONARQUBE_PORT}"
POSTGRES_PASSWORD="sonar123"
SONAR_PASSWORD="admin"

# Parse arguments
SKIP_TESTS=false
PROJECT_PATH=""
DOCKER_ACTION=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        --stop)
            DOCKER_ACTION="stop"
            shift
            ;;
        --restart)
            DOCKER_ACTION="restart"
            shift
            ;;
        --clean)
            DOCKER_ACTION="clean"
            shift
            ;;
        --help)
            echo "Usage: $0 [project-path] [--skip-tests] [--stop|--restart|--clean]"
            echo ""
            echo "Options:"
            echo "  project-path   Path to the Maven project (required for analysis - must contain pom.xml)"
            echo "  --skip-tests   Skip test execution during Maven build"
            echo "  --stop         Stop SonarQube containers (saves resources)"
            echo "  --restart      Restart SonarQube containers (fresh start)"
            echo "  --clean        Automatically remove containers and volumes (complete reset)"
            echo ""
            echo "Analysis Examples:"
            echo "  $0 backend/custom-service                                     # Analyze project with tests"
            echo "  $0 ../other-repo/my-project                                   # Analyze project in different repo with tests"
            echo "  $0 backend/integration-service --skip-tests                   # Analyze project without tests"
            echo "  $0 /absolute/path/to/project --skip-tests                     # Analyze with absolute path without tests"
            echo ""
            echo "Docker Management Examples:"
            echo "  $0 --stop         # Stop containers to save resources"
            echo "  $0 --restart      # Restart containers for fresh start"
            echo "  $0 --clean        # Complete reset (removes all analysis history)"
            exit 0
            ;;
        *)
            if [ -z "$PROJECT_PATH" ]; then
                PROJECT_PATH="$1"
            fi
            shift
            ;;
    esac
done

# Handle Docker management actions first
if [ -n "$DOCKER_ACTION" ]; then
    case $DOCKER_ACTION in
        "stop")
            echo -e "${BLUE}🛑 Stopping SonarQube containers...${NC}"
            docker stop $SONARQUBE_CONTAINER_NAME $POSTGRES_CONTAINER_NAME 2>/dev/null || echo -e "${YELLOW}ℹ️  Containers were not running${NC}"
            echo -e "${GREEN}✅ SonarQube containers stopped${NC}"
            echo -e "${CYAN}💡 Run without --stop to start them again for analysis${NC}"
            exit 0
            ;;
        "restart")
            echo -e "${BLUE}🔄 Restarting SonarQube containers...${NC}"
            docker stop $SONARQUBE_CONTAINER_NAME $POSTGRES_CONTAINER_NAME 2>/dev/null || echo -e "${YELLOW}ℹ️  Containers were not running${NC}"
            docker start $POSTGRES_CONTAINER_NAME 2>/dev/null || echo -e "${YELLOW}ℹ️  PostgreSQL container not found, will be created${NC}"
            docker start $SONARQUBE_CONTAINER_NAME 2>/dev/null || echo -e "${YELLOW}ℹ️  SonarQube container not found, will be created${NC}"
            echo -e "${GREEN}✅ SonarQube containers restarted${NC}"
            echo -e "${CYAN}💡 Containers are ready. Run analysis with project path${NC}"
            exit 0
            ;;
        "clean")
            echo -e "${BLUE}🗑️  Performing automatic clean installation...${NC}"
            echo -e "${YELLOW}⚠️  Removing all SonarQube data and analysis history${NC}"

            # Remove containers by specific names
            docker rm -f $SONARQUBE_CONTAINER_NAME $POSTGRES_CONTAINER_NAME 2>/dev/null || echo -e "${YELLOW}ℹ️  Named containers already removed${NC}"

            # Also remove any containers that might contain "sonarqube" in their name (for cleanup of old setups)
            SONAR_CONTAINERS=$(docker ps -aq --filter "name=sonarqube" 2>/dev/null)
            if [ -n "$SONAR_CONTAINERS" ]; then
                echo -e "${YELLOW}🧹 Found additional SonarQube containers, removing them...${NC}"
                docker rm -f $SONAR_CONTAINERS 2>/dev/null || true
            fi

            docker volume prune -f
            echo -e "${GREEN}✅ SonarQube completely cleaned - ready for fresh installation${NC}"
            echo -e "${CYAN}💡 Next analysis will create fresh containers with consistent authentication${NC}"
            exit 0
            ;;
    esac
fi

# Project configuration - validate and resolve project path
# Require explicit project path to avoid confusion
if [ -z "$PROJECT_PATH" ]; then
    echo -e "${RED}❌ Error: Project path is required${NC}"
    echo -e "${RED}   Please specify the path to a Maven project containing pom.xml${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 backend/custom-service"
    echo "  $0 ../other-repo/my-project --skip-tests"
    exit 1
fi

# Check if the path exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}❌ Error: Directory does not exist: $PROJECT_PATH${NC}"
    echo -e "${RED}   Please provide a valid project directory path${NC}"
    exit 1
fi

# Resolve absolute path
PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

# Extract project name and key from the last part of the path
PROJECT_NAME="$(basename "$PROJECT_PATH")"
PROJECT_KEY="$PROJECT_NAME"

echo -e "${BLUE}==============================================================================${NC}"
echo -e "${BLUE}SONARQUBE ANALYSIS SETUP${NC}"
echo -e "${BLUE}==============================================================================${NC}"
echo -e "Repository/Project Key: ${GREEN}$PROJECT_KEY${NC}"
echo -e "Project Display Name: ${GREEN}$PROJECT_NAME${NC}"
echo -e "Project Path: ${GREEN}$PROJECT_PATH${NC}"
echo -e "SonarQube URL: ${GREEN}$SONARQUBE_URL${NC}"
if [ "$SKIP_TESTS" = true ]; then
    echo -e "Tests: ${YELLOW}SKIPPED${NC} (using --skip-tests flag)"
else
    echo -e "Tests: ${GREEN}INCLUDED${NC} (default behavior)"
fi
echo ""

# Function to check if container is running
is_container_running() {
    docker ps --filter "name=$1" --filter "status=running" --format "{{.Names}}" | grep -q "^$1$"
}

# Function to check if container exists (running or stopped)
container_exists() {
    docker ps -a --filter "name=$1" --format "{{.Names}}" | grep -q "^$1$"
}

# Function to wait for SonarQube to be ready and setup authentication
wait_for_sonarqube() {
    echo -e "${YELLOW}⏳ Waiting for SonarQube to be ready...${NC}"
    local max_attempts=60
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -s "$SONARQUBE_URL/api/system/status" | grep -q '"status":"UP"'; then
            echo -e "${GREEN}✅ SonarQube is ready!${NC}"
            setup_sonarqube_authentication
            return 0
        fi

        echo -e "${YELLOW}   Attempt $attempt/$max_attempts - SonarQube starting up...${NC}"
        sleep 5
        ((attempt++))
    done

    echo -e "${RED}❌ SonarQube failed to start within expected time${NC}"
    exit 1
}

# Function to setup SonarQube authentication for fresh installations
setup_sonarqube_authentication() {
    echo "🔐 Setting up SonarQube authentication for seamless analysis..."

    # Wait for SonarQube to be fully ready
    local max_setup_attempts=10
    local setup_attempt=1

    while [ $setup_attempt -le $max_setup_attempts ]; do
        # Check SonarQube health and API availability
        echo "📋 Checking SonarQube configuration (attempt $setup_attempt/$max_setup_attempts)..."
        local health_response=$(curl -s -u admin:admin "$SONARQUBE_URL/api/system/health" 2>/dev/null)

        if echo "$health_response" | grep -q '"health":"GREEN"'; then
            echo "✅ SonarQube is healthy and ready for configuration"
            break
        elif [ $setup_attempt -eq $max_setup_attempts ]; then
            echo "⚠️  SonarQube health check failed, proceeding with basic setup..."
            break
        else
            echo "   Waiting for SonarQube to be fully ready..."
            sleep 3
            ((setup_attempt++))
        fi
    done

    # Disable force authentication for seamless analysis
    echo "🔧 Disabling force authentication..."
    local auth_result=$(curl -s -u admin:admin -X POST \
        "http://localhost:9000/api/settings/set?key=sonar.forceAuthentication&value=false" 2>/dev/null)

    # Configure project-level scan permissions
    echo "🔧 Configuring project-level scan permissions..."
    # Get default permission template ID (more robust extraction)
    local template_id=$(curl -s -u admin:admin "http://localhost:9000/api/permissions/search_templates" 2>/dev/null | \
        grep -o '"id":"[0-9a-f-]*"' | head -1 | cut -d'"' -f4)

    if [ -n "$template_id" ]; then
        # Add scan permission for 'anyone' group to the default template
        curl -s -u admin:admin -X POST \
            "http://localhost:9000/api/permissions/add_group_to_template?templateId=$template_id&permission=scan&groupName=anyone" >/dev/null 2>&1
        echo "   ✓ Template permissions configured"
    else
        echo "   ⚠️  Could not find default template, using fallback configuration"
    fi

    # Configure global permissions for seamless development
    echo "🔧 Configuring global permissions for seamless development..."
    # Add global provisioning and scan permissions to 'sonar-users' and 'anyone' groups
    curl -s -u admin:admin -X POST "http://localhost:9000/api/permissions/add_group?permission=provisioning&groupName=sonar-users" >/dev/null 2>&1
    curl -s -u admin:admin -X POST "http://localhost:9000/api/permissions/add_group?permission=scan&groupName=sonar-users" >/dev/null 2>&1
    curl -s -u admin:admin -X POST "http://localhost:9000/api/permissions/add_group?permission=provisioning&groupName=anyone" >/dev/null 2>&1
    curl -s -u admin:admin -X POST "http://localhost:9000/api/permissions/add_group?permission=scan&groupName=anyone" >/dev/null 2>&1

    # Verify the authentication setup
    echo "🔍 Verifying authentication configuration..."
    local auth_status=$(curl -s -u admin:admin "$SONARQUBE_URL/api/settings/values?keys=sonar.forceAuthentication" 2>/dev/null | grep '"value":"false"')

    if [ -n "$auth_status" ]; then
        echo "✅ SonarQube configured for seamless authentication-free analysis"
        echo "🎯 Developers can now focus on the analysis dashboard without authentication issues"
        echo "🧪 Authentication setup is consistent - perfect for testing!"
    else
        echo "⚠️  Authentication setup completed with fallback configuration"
        echo "🔧 Analysis will still work but may require basic authentication"
    fi

    # Clear token to use no authentication
    SONAR_USER_TOKEN=""
}

# Step 1: Check if PostgreSQL is running
echo -e "${BLUE}📋 Step 1: Setting up PostgreSQL database...${NC}"
if is_container_running "$POSTGRES_CONTAINER_NAME"; then
    echo -e "${GREEN}✅ PostgreSQL container is already running${NC}"
elif container_exists "$POSTGRES_CONTAINER_NAME"; then
    echo -e "${YELLOW}🔄 Starting existing PostgreSQL container...${NC}"
    docker start --platform linux/amd64 "$POSTGRES_CONTAINER_NAME"
else
    echo -e "${YELLOW}🚀 Creating and starting PostgreSQL container...${NC}"
    docker run -d \
        --name "$POSTGRES_CONTAINER_NAME" \
        -e POSTGRES_DB=sonar \
        -e POSTGRES_USER=sonar \
        -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
        -p 5432:5432 \
        bitnamilegacy/postgresql:11.14.0
fi

# Step 2: Setup SonarQube
echo -e "\n${BLUE}📋 Step 2: Setting up SonarQube...${NC}"
if is_container_running "$SONARQUBE_CONTAINER_NAME"; then
    echo -e "${GREEN}✅ SonarQube container is already running${NC}"
elif container_exists "$SONARQUBE_CONTAINER_NAME"; then
    echo -e "${YELLOW}🔄 Starting existing SonarQube container...${NC}"
    docker start  "$SONARQUBE_CONTAINER_NAME"
    wait_for_sonarqube
else
    echo -e "${YELLOW}🚀 Pulling SonarQube image...${NC}"
    docker pull --platform linux/amd64 "sonarqube:$SONARQUBE_VERSION"

    echo -e "${YELLOW}🚀 Creating and starting SonarQube container...${NC}"
    docker run -d \
        --name "$SONARQUBE_CONTAINER_NAME" \
        -p "$SONARQUBE_PORT:9000" \
        -e SONAR_JDBC_URL=jdbc:postgresql://host.docker.internal:5432/sonar \
        -e SONAR_JDBC_USERNAME=sonar \
        -e SONAR_JDBC_PASSWORD="$POSTGRES_PASSWORD" \
        -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
        -e SONAR_FORCEAUTHENTICATION=false \
        -e SONAR_SECURITY_REALM= \
        -v sonarqube_data:/opt/sonarqube/data \
        -v sonarqube_logs:/opt/sonarqube/logs \
        -v sonarqube_extensions:/opt/sonarqube/extensions \
        "sonarqube:$SONARQUBE_VERSION"

    wait_for_sonarqube
fi

# Step 3: Build the project with coverage
echo -e "\n${BLUE}📋 Step 3: Building project with test coverage...${NC}"
if [ ! -f "$PROJECT_PATH/pom.xml" ]; then
    echo -e "${RED}❌ No pom.xml found in project directory: $PROJECT_PATH${NC}"
    echo -e "${RED}   Please provide a valid Maven project path${NC}"
    exit 1
fi

if [ "$SKIP_TESTS" = true ]; then
    echo -e "${YELLOW}🔨 Running Maven clean compile (skipping tests as requested)...${NC}"
else
    echo -e "${YELLOW}🔨 Running Maven clean verify to generate coverage reports...${NC}"
fi

# Check if SETTINGS_XML is set, otherwise use default
if [ -z "$SETTINGS_XML" ]; then
    if [ -f "$HOME/.m2/settings.xml" ]; then
        SETTINGS_XML="$HOME/.m2/settings.xml"
        echo -e "${YELLOW}ℹ️  Using default Maven settings: $SETTINGS_XML${NC}"
    else
        echo -e "${YELLOW}ℹ️  No settings.xml specified, using Maven defaults${NC}"
        SETTINGS_XML=""
    fi
else
    echo -e "${YELLOW}ℹ️  Using specified Maven settings: $SETTINGS_XML${NC}"
fi

# Build Maven command
if [ "$SKIP_TESTS" = true ]; then
    MVN_CMD="mvn clean compile -DskipTests"
else
    MVN_CMD="mvn clean verify"
fi
if [ -n "$SETTINGS_XML" ]; then
    MVN_CMD="$MVN_CMD -s $SETTINGS_XML"
fi

# Change to project directory and execute Maven build
echo -e "${YELLOW}📂 Changing to project directory: $PROJECT_PATH${NC}"
cd "$PROJECT_PATH"
echo "Running command: $MVN_CMD"
$MVN_CMD

# Step 4: Check for coverage reports
echo -e "\n${BLUE}📋 Step 4: Checking for coverage reports...${NC}"
COVERAGE_REPORT_PATHS=""

if [ -f "target/site/jacoco-all/jacoco.xml" ]; then
    COVERAGE_REPORT_PATHS="target/site/jacoco-all/jacoco.xml"
    echo -e "${GREEN}✅ Found merged coverage report: jacoco-all/jacoco.xml${NC}"
elif [ -f "target/site/jacoco/jacoco.xml" ]; then
    COVERAGE_REPORT_PATHS="target/site/jacoco/jacoco.xml"
    echo -e "${GREEN}✅ Found standard coverage report: jacoco/jacoco.xml${NC}"
elif [ -f "target/site/jacoco-ut/jacoco.xml" ] && [ -f "target/site/jacoco-it/jacoco.xml" ]; then
    COVERAGE_REPORT_PATHS="target/site/jacoco-ut/jacoco.xml,target/site/jacoco-it/jacoco.xml"
    echo -e "${GREEN}✅ Found separate UT+IT coverage reports${NC}"
elif [ -f "target/site/jacoco-ut/jacoco.xml" ]; then
    COVERAGE_REPORT_PATHS="target/site/jacoco-ut/jacoco.xml"
    echo -e "${YELLOW}⚠️  Found only unit test coverage report${NC}"
else
    echo -e "${YELLOW}⚠️  No JaCoCo coverage reports found - analysis will run without coverage${NC}"
fi

# Step 5: Create SonarQube project if it doesn't exist
echo -e "\n${BLUE}📋 Step 5: Ensuring SonarQube project exists...${NC}"

# Step 5: Run SonarQube analysis
echo -e "\n${BLUE}📋 Step 5: Running SonarQube analysis...${NC}"

# Ensure we're still in the project directory and prepare project version
cd "$PROJECT_PATH"
# Use Git commit ID as version for consistent tracking across builds
PROJECT_VERSION=$(git rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "unknown")

# Build SonarQube analysis command
SONAR_CMD="mvn sonar:sonar"
if [ -n "$SETTINGS_XML" ]; then
    SONAR_CMD="$SONAR_CMD -s $SETTINGS_XML"
fi

# Build SonarQube command for seamless local development (no authentication required)
SONAR_CMD="$SONAR_CMD \
    -Dsonar.host.url=$SONARQUBE_URL \
    -Dsonar.projectKey=$PROJECT_KEY \
    -Dsonar.projectName=\"$PROJECT_NAME\" \
    -Dsonar.projectVersion=$PROJECT_VERSION \
    -Dsonar.qualitygate.wait=false"

if [ -n "$COVERAGE_REPORT_PATHS" ]; then
    SONAR_CMD="$SONAR_CMD -Dsonar.coverage.jacoco.xmlReportPaths=\"$COVERAGE_REPORT_PATHS\""
fi

echo -e "${YELLOW}🔍 Running SonarQube analysis...${NC}"
echo -e "${BLUE}Command: $SONAR_CMD${NC}"
echo ""

# Execute SonarQube analysis
eval $SONAR_CMD

# Check if analysis was successful
if [ $? -eq 0 ]; then
    # Step 7: Display results and provide SonarQube link
    echo -e "\n${BLUE}==============================================================================${NC}"
    echo -e "${GREEN}🎉 SonarQube analysis completed successfully!${NC}"
    echo -e "${BLUE}==============================================================================${NC}"
    echo -e ""
    echo -e "📊 ${GREEN}View Project Dashboard:${NC} ${BLUE}$SONARQUBE_URL/dashboard?id=$PROJECT_KEY${NC}"
    echo -e "🏠 ${GREEN}SonarQube Home:${NC} ${BLUE}$SONARQUBE_URL${NC}"
    echo -e ""
    echo -e "${CYAN}✨ Ready for Development:${NC}"
    echo -e "   • SonarQube server is running and accessible"
    echo -e "   • Authentication automatically configured"
    echo -e "   • Project analysis completed and visible in dashboard"
    echo -e "   • No additional setup required - start browsing results!"
    echo -e ""
else
    echo -e "\n${RED}❌ SonarQube analysis failed!${NC}"
    echo -e "${YELLOW}💡 SonarQube Server: $SONARQUBE_URL (check if accessible)${NC}"
fi

# Step 8: Management commands
echo -e "\n${BLUE}🛠️  Management Commands:${NC}"
echo -e "   Stop SonarQube: ${YELLOW}docker stop $SONARQUBE_CONTAINER_NAME${NC}"
echo -e "   Start SonarQube: ${YELLOW}docker start $SONARQUBE_CONTAINER_NAME${NC}"
echo -e "   Remove containers: ${YELLOW}docker rm -f $SONARQUBE_CONTAINER_NAME $POSTGRES_CONTAINER_NAME${NC}"
echo -e "   Remove volumes: ${YELLOW}docker volume prune${NC}"
echo -e ""
echo -e "📊 View results at: ${GREEN}$SONARQUBE_URL${NC}"
echo -e "   Project: ${GREEN}$PROJECT_NAME${NC} (Key: ${GREEN}$PROJECT_KEY${NC})"
echo -e "   Version: ${GREEN}$PROJECT_VERSION${NC}"
echo -e ""
echo -e "${GREEN}✅ Setup complete! You can now run this script in any backend repository.${NC}"
