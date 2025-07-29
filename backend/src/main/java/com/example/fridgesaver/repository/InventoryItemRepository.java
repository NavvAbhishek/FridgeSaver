package com.example.fridgesaver.repository;

import com.example.fridgesaver.entity.InventoryItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InventoryItemRepository extends JpaRepository<InventoryItem, Long> {

    // Custom query to find all items for a specific user, sorted by expiry date ascending.
    List<InventoryItem> findByUser_IdOrderByExpiryDateAsc(Long userId);
}