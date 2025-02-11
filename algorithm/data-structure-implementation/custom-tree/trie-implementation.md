# Trie Implementation

## About

A **Trie** (pronounced "try") is a tree-like data structure used for storing a **dynamic set of strings**, often for fast retrieval of words with common prefixes.

## **Operations in Trie**

### **Insert (O(n))**

* Traverse the Trie following each character in the word.
* If a character’s node does not exist, create a new node.
* Mark the last node as an **end of a word**.

### **Search (O(n))**

* Traverse the Trie following each character in the word.
* If we reach the last character and the node is marked as an **end of a word**, return **true**.
* Otherwise, return **false**.

### **Starts With (Prefix Search) (O(n))**

* Similar to search, but instead of checking the **end of word**, just ensure the prefix exists.

### **Delete (O(n))**

* Perform a **search** for the word.
* If found, unmark the last character’s **end of word flag**.
* Recursively delete unused nodes (if they are not part of another word).

## **Trie Implementation in Java**

```java
class TrieNode {
    TrieNode[] children;
    boolean isEndOfWord;

    public TrieNode() {
        children = new TrieNode[26]; // Assuming only lowercase 'a' to 'z'
        isEndOfWord = false;
    }
}

public class Trie {
    private final TrieNode root;

    public Trie() {
        root = new TrieNode();
    }

    // Insert a word into the trie
    public void insert(String word) {
        TrieNode node = root;
        for (char ch : word.toCharArray()) {
            int index = ch - 'a';
            if (node.children[index] == null) {
                node.children[index] = new TrieNode();
            }
            node = node.children[index];
        }
        node.isEndOfWord = true; // Mark last node as end of word
    }

    // Search for a word in the trie
    public boolean search(String word) {
        TrieNode node = getNode(word);
        return node != null && node.isEndOfWord;
    }

    // Check if a prefix exists in the trie
    public boolean startsWith(String prefix) {
        return getNode(prefix) != null;
    }

    // Helper method to get the last node of a given string
    private TrieNode getNode(String word) {
        TrieNode node = root;
        for (char ch : word.toCharArray()) {
            int index = ch - 'a';
            if (node.children[index] == null) {
                return null;
            }
            node = node.children[index];
        }
        return node;
    }

    // Delete a word from the trie
    public boolean delete(String word) {
        return deleteHelper(root, word, 0);
    }

    private boolean deleteHelper(TrieNode node, String word, int depth) {
        if (node == null) return false;

        if (depth == word.length()) {
            if (!node.isEndOfWord) return false;
            node.isEndOfWord = false;
            return isEmpty(node); // If true, delete node from parent
        }

        int index = word.charAt(depth) - 'a';
        if (deleteHelper(node.children[index], word, depth + 1)) {
            node.children[index] = null; // Remove reference if child is empty
            return !node.isEndOfWord && isEmpty(node);
        }
        return false;
    }

    // Helper method to check if a node has children
    private boolean isEmpty(TrieNode node) {
        for (TrieNode child : node.children) {
            if (child != null) return false;
        }
        return true;
    }

    // Print all words stored in Trie
    public void printAllWords() {
        printHelper(root, "");
    }

    private void printHelper(TrieNode node, String prefix) {
        if (node.isEndOfWord) {
            System.out.println(prefix);
        }
        for (char ch = 'a'; ch <= 'z'; ch++) {
            int index = ch - 'a';
            if (node.children[index] != null) {
                printHelper(node.children[index], prefix + ch);
            }
        }
    }
}

// Main class to test Trie
public class TrieDemo {
    public static void main(String[] args) {
        Trie trie = new Trie();
        trie.insert("apple");
        trie.insert("app");
        trie.insert("bat");

        System.out.println("Search 'apple': " + trie.search("apple")); // true
        System.out.println("Search 'app': " + trie.search("app")); // true
        System.out.println("Prefix 'ap': " + trie.startsWith("ap")); // true
        System.out.println("Prefix 'bat': " + trie.startsWith("bat")); // true
        System.out.println("Prefix 'b': " + trie.startsWith("b")); // true
        System.out.println("Prefix 'cat': " + trie.startsWith("cat")); // false

        System.out.println("Deleting 'apple': " + trie.delete("apple"));
        System.out.println("Search 'apple': " + trie.search("apple")); // false
        System.out.println("Search 'app': " + trie.search("app")); // true

        System.out.println("All words in Trie:");
        trie.printAllWords(); // Expected: app, bat
    }
}
```

## **Time Complexity Analysis**

| Operation       | Time Complexity |
| --------------- | --------------- |
| Insert          | O(n)            |
| Search          | O(n)            |
| Starts With     | O(n)            |
| Delete          | O(n)            |
| Print All Words | O(n)            |

`n = length of the word being inserted/searched`

