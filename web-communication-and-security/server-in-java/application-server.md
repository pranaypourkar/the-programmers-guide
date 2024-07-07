# Application Server

## About

An application server is a Java Virtual Machine (JVM) that runs user applications. The application server collaborates with the web server to return a dynamic, customized response to a client request. The client request can consist of servlets, JavaServer Pages (JSP) files, and enterprise beans, and their supporting classes.

For example, a user at a web browser visits a company website:

1. The user requests access to data in a database.
2. The user request flows to the web server.
3. The web server determines that the request involves an application containing resources not handled directly by the web server (such as servlets). It forwards the request to one of its application servers on which the application is running.
4. The invoked application then processes the user request. For example:
   * An application servlet prepares the user request for processing by an enterprise bean that performs the database access.
   * The application produces a dynamic web page containing the results of the user query.
5. The application server collaborates with the web server to return the results to the user at the web browser.
