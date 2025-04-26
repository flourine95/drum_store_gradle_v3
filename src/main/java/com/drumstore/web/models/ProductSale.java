package com.drumstore.web.models;

import java.sql.Timestamp;

public class ProductSale {
    private int id;
    private int productId;
    private int saleId;
    private Timestamp createdAt;

    private Sale sale;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getSaleId() {
        return saleId;
    }

    public void setSaleId(int saleId) {
        this.saleId = saleId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Sale getSale() {
        return sale;
    }

    public void setSale(Sale sale) {
        this.sale = sale;
    }

    @Override
    public String toString() {
        return "ProductSale{" +
                "id=" + id +
                ", productId=" + productId +
                ", saleId=" + saleId +
                ", createdAt=" + createdAt +
                ", sale=" + sale +
                '}';
    }
}
