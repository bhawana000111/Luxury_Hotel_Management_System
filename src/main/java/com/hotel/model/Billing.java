package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Billing model class
 */
public class Billing {
    private int id;
    private int bookingId;
    private BigDecimal amount;
    private Timestamp paidOn;
    private String paymentMethod;
    private String transactionId;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Additional fields for joining with other tables
    private String userName;
    private String roomNumber;
    private Date bookingDateFrom;
    private Date bookingDateTo;

    // Default constructor
    public Billing() {
    }

    // Constructor with essential fields
    public Billing(int bookingId, BigDecimal amount) {
        this.bookingId = bookingId;
        this.amount = amount;
        this.status = "PENDING";
    }

    // Constructor with all fields
    public Billing(int id, int bookingId, BigDecimal amount, Timestamp paidOn,
                  String paymentMethod, String transactionId, String status,
                  Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.bookingId = bookingId;
        this.amount = amount;
        this.paidOn = paidOn;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Timestamp getPaidOn() {
        return paidOn;
    }

    public void setPaidOn(Timestamp paidOn) {
        this.paidOn = paidOn;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Date getBookingDateFrom() {
        return bookingDateFrom;
    }

    public void setBookingDateFrom(Date bookingDateFrom) {
        this.bookingDateFrom = bookingDateFrom;
    }

    public Date getBookingDateTo() {
        return bookingDateTo;
    }

    public void setBookingDateTo(Date bookingDateTo) {
        this.bookingDateTo = bookingDateTo;
    }

    @Override
    public String toString() {
        return "Billing{" +
                "id=" + id +
                ", bookingId=" + bookingId +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                '}';
    }
}
