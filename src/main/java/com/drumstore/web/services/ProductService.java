package com.drumstore.web.services;

import com.drumstore.web.dto.*;
import com.drumstore.web.repositories.ProductRepository;

import java.util.List;

public class ProductService {
    private final ProductRepository productRepository = new ProductRepository();

    public List<ProductDashboardDTO> all() {
        return productRepository.all();
    }

    public int create(ProductCreateDTO product) {
        return productRepository.store(product);
    }

    public int createImage(int productId, ProductImageDTO productImage) {
        return productRepository.storeImage(productId, productImage);
    }

    public ProductDashboardDetailDTO find(int id) {
        return productRepository.findById(id);
    }

    public int countProducts(String search, String category, String brand, String priceRange) {
        return productRepository.countFilteredProducts(search, category, brand, priceRange);
    }

    public List<ProductCardDTO> getProductCards(int page, int limit, String search, String category, String brand, String priceRange, String sortBy) {
        int offset = (page - 1) * limit;
        return productRepository.getFilteredProductCards(offset, limit, search, category, brand, priceRange, sortBy);
    }

    public ProductDetailDTO getProductDetail(int id) {
        ProductDetailDTO product = productRepository.findProductDetail(id);
        if (product != null) {
            productRepository.incrementViewCount(id);
        }
        return product;
    }

    public CartItemDTO findProductForCartItem(int productVariantId, int productId) {
        CartItemDTO cartItemDTO = productRepository.findMainProductVariant(productVariantId);
        cartItemDTO.setVariants(productRepository.findAllVariants(productId));
        return cartItemDTO;
    }

    public CartItemDTO findProductWithVariantForCartItem(int colorId, int addonId, int productId) {
        CartItemDTO cartItemDTO = productRepository.findProductWithVariant(colorId, addonId, productId);
        cartItemDTO.setVariants(productRepository.findAllVariants(productId));
        return cartItemDTO;
    }

    public ProductEditDTO findProductEdit(int id) {
        return productRepository.findProductEdit(id);
    }

    public int createColor(int productId, ProductColorDTO color) {
        return productRepository.storeColor(productId, color);
    }

    public int createAddon(int productId, ProductAddonDTO addon) {
        return productRepository.storeAddon(productId, addon);
    }

    public int createVariant(int productId, ProductVariantDTO variant) {
        return productRepository.storeVariant(productId, variant);
    }

    public void update(ProductEditDTO productEditDTO) {
        productRepository.update(productEditDTO);
    }

    public void updateColors(Integer id, String[] colorIds, String[] colorNames, String[] colorPrices) {
        
    }

    public void updateColors(List<ProductColorDTO> colors) {
        for (ProductColorDTO color : colors) {
            productRepository.updateColor(color);
        }
    }

    public void updateAddons(List<ProductAddonDTO> addons) {
        for (ProductAddonDTO addon : addons) {
            productRepository.updateAddon(addon);
        }
    }

    public void updateVariants(List<ProductVariantDTO> variants) {
        for (ProductVariantDTO variant : variants) {
            productRepository.updateVariant(variant);
        }
    }

    public void updateMainImage(ProductImageDTO imageDTO) {
        productRepository.updateMainImage(imageDTO);
    }
    
    public List<ProductImageDTO> getProductImages(int productId) {
        return productRepository.getProductImages(productId);
    }
    
    public void deleteImage(int imageId) {
        productRepository.deleteImage(imageId);
    }
    
    public void addImage(ProductImageDTO imageDTO) {
        productRepository.storeImage(imageDTO.getProductId(), imageDTO);
    }
    
    public void updateImage(ProductImageDTO imageDTO) {
        productRepository.updateImage(imageDTO);
    }
}
