package com.example.fridgesaver.controller;

import com.example.fridgesaver.dto.InventoryItemRequest;
import com.example.fridgesaver.entity.InventoryItem;
import com.example.fridgesaver.security.UserDetailsImpl;
import com.example.fridgesaver.service.InventoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    @Autowired
    private InventoryService inventoryService;

    // Get all items for the logged-in user
    @GetMapping
    public ResponseEntity<List<InventoryItem>> getUserInventory(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        List<InventoryItem> items = inventoryService.getItemsForUser(userDetails.getId());
        return ResponseEntity.ok(items);
    }

    // Add a new item for the logged-in user
    @PostMapping
    public ResponseEntity<InventoryItem> addItem(@Valid @RequestBody InventoryItemRequest itemRequest,
                                                 @AuthenticationPrincipal UserDetailsImpl userDetails) {
        InventoryItem newItem = inventoryService.addItem(itemRequest, userDetails.getId());
        return ResponseEntity.ok(newItem);
    }

    // Update an existing item
    @PutMapping("/{id}")
    public ResponseEntity<InventoryItem> updateItem(@PathVariable Long id,
                                                    @Valid @RequestBody InventoryItemRequest itemRequest,
                                                    @AuthenticationPrincipal UserDetailsImpl userDetails) {
        InventoryItem updatedItem = inventoryService.updateItem(id, itemRequest, userDetails.getId());
        return ResponseEntity.ok(updatedItem);
    }

    // Delete an item
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteItem(@PathVariable Long id,
                                        @AuthenticationPrincipal UserDetailsImpl userDetails) {
        inventoryService.deleteItem(id, userDetails.getId());
        return ResponseEntity.ok("Item deleted successfully");
    }
}