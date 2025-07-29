package com.example.fridgesaver.service;

import com.example.fridgesaver.dto.InventoryItemRequest;
import com.example.fridgesaver.entity.InventoryItem;
import com.example.fridgesaver.entity.User;
import com.example.fridgesaver.repository.InventoryItemRepository;
import com.example.fridgesaver.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class InventoryService {

    @Autowired
    private InventoryItemRepository inventoryItemRepository;

    @Autowired
    private UserRepository userRepository;

    public List<InventoryItem> getItemsForUser(Long userId) {
        return inventoryItemRepository.findByUser_IdOrderByExpiryDateAsc(userId);
    }

    public InventoryItem addItem(InventoryItemRequest itemRequest, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        InventoryItem newItem = new InventoryItem();
        newItem.setName(itemRequest.getName());
        newItem.setQuantity(itemRequest.getQuantity());
        newItem.setExpiryDate(itemRequest.getExpiryDate());
        newItem.setImageUrl(itemRequest.getImageUrl());
        newItem.setUser(user);

        return inventoryItemRepository.save(newItem);
    }

    public InventoryItem updateItem(Long itemId, InventoryItemRequest itemRequest, Long userId) {
        InventoryItem item = inventoryItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        // Security check: ensure the item belongs to the logged-in user
        if (!item.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("You do not have permission to update this item.");
        }

        item.setName(itemRequest.getName());
        item.setQuantity(itemRequest.getQuantity());
        item.setExpiryDate(itemRequest.getExpiryDate());
        item.setImageUrl(itemRequest.getImageUrl());

        return inventoryItemRepository.save(item);
    }

    public void deleteItem(Long itemId, Long userId) {
        InventoryItem item = inventoryItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        // Security check: ensure the item belongs to the logged-in user
        if (!item.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("You do not have permission to delete this item.");
        }

        inventoryItemRepository.delete(item);
    }
}