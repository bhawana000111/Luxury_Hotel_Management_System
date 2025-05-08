package com.hotel.util;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Utility class for caching data to improve performance
 */
public class CacheUtil {
    
    private static final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    
    // Default cache expiration time in seconds
    private static final int DEFAULT_EXPIRATION_TIME = 300; // 5 minutes
    
    static {
        // Schedule cache cleanup task
        scheduler.scheduleAtFixedRate(CacheUtil::cleanupCache, 60, 60, TimeUnit.SECONDS);
    }
    
    /**
     * Get a value from the cache
     * @param key The cache key
     * @return The cached value, or null if not found or expired
     */
    public static Object get(String key) {
        CacheEntry entry = cache.get(key);
        
        if (entry != null && !entry.isExpired()) {
            return entry.getValue();
        }
        
        // Remove expired entry
        if (entry != null && entry.isExpired()) {
            cache.remove(key);
        }
        
        return null;
    }
    
    /**
     * Put a value in the cache with default expiration time
     * @param key The cache key
     * @param value The value to cache
     */
    public static void put(String key, Object value) {
        put(key, value, DEFAULT_EXPIRATION_TIME);
    }
    
    /**
     * Put a value in the cache with custom expiration time
     * @param key The cache key
     * @param value The value to cache
     * @param expirationTimeInSeconds The expiration time in seconds
     */
    public static void put(String key, Object value, int expirationTimeInSeconds) {
        long expirationTime = System.currentTimeMillis() + (expirationTimeInSeconds * 1000);
        cache.put(key, new CacheEntry(value, expirationTime));
    }
    
    /**
     * Remove a value from the cache
     * @param key The cache key
     */
    public static void remove(String key) {
        cache.remove(key);
    }
    
    /**
     * Clear the entire cache
     */
    public static void clear() {
        cache.clear();
    }
    
    /**
     * Clean up expired cache entries
     */
    private static void cleanupCache() {
        long now = System.currentTimeMillis();
        
        cache.entrySet().removeIf(entry -> entry.getValue().getExpirationTime() < now);
    }
    
    /**
     * Cache entry class
     */
    private static class CacheEntry {
        private final Object value;
        private final long expirationTime;
        
        public CacheEntry(Object value, long expirationTime) {
            this.value = value;
            this.expirationTime = expirationTime;
        }
        
        public Object getValue() {
            return value;
        }
        
        public long getExpirationTime() {
            return expirationTime;
        }
        
        public boolean isExpired() {
            return System.currentTimeMillis() > expirationTime;
        }
    }
}
