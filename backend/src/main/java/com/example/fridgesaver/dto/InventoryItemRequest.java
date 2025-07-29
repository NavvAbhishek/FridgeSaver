package com.example.fridgesaver.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class InventoryItemRequest {

    @NotBlank(message = "Item name cannot be blank")
    private String name;

    @Min(value = 1, message = "Quantity must be at least 1")
    private int quantity;

    @NotNull(message = "Expiry date is required")
    @FutureOrPresent(message = "Expiry date must be today or in the future")
    private LocalDate expiryDate;

    private String imageUrl;
}
