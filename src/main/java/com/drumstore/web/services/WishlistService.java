package com.drumstore.web.services;

import com.drumstore.web.dto.ProductDetailDTO;
import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.models.User;
import com.drumstore.web.models.WishList;
import com.drumstore.web.repositories.WishListRepository;

import java.util.ArrayList;
import java.util.List;

public class WishlistService {
    private final WishListRepository wishListRepository = new WishListRepository();
    private final ProductService productService = new ProductService();

    public List<ProductDetailDTO> getAll(int userId){
        return wishListRepository.getAll(userId).stream()
                .map(wishList -> productService.getProductDetail(wishList.getProductId()))
                .toList();
    }

    public boolean isExitsInWishlist(int productId, int userId) {
        return wishListRepository.isExists(productId, userId);
    }

    public void save(int productId, int userId) {
        WishList wishList = new WishList();
        wishList.setProductId(productId);
        wishList.setUserId(userId);
        wishList.setCreatedAt();
        wishListRepository.save(wishList);
    }


    public boolean toogleWishtList(int productId, int userId) {
        boolean isExist = wishListRepository.isExists(productId, userId);
        if (isExist) {
            wishListRepository.delete(productId, userId);
            return false;
        }
        save(productId, userId);
        return true;
    }
}
