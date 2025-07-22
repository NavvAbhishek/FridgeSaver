package com.example.fridgesaver.dto;

public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private Long id;
    private String name;

    public JwtResponse(String accessToken, Long id, String name) {
        this.token = accessToken;
        this.id = id;
        this.name = name;
    }

    // Getters and Setters
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}