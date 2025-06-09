package com.dompetku.model;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;

    // getter & setter 
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    
    public void setUsername(String username) { this.username = username; }
    public String getUsername() { return username; }

    public void setPassword(String password) { this.password = password; }
    public String getPassword() { return password; }

    public void setId(int id) { this.id = id; }
    public int getId() { return id; }
}
