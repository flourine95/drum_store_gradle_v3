package com.drumstore.web.listeners;

import com.drumstore.web.utils.DBConnection;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class MySQLCleanupListener implements ServletContextListener {
    private static final Logger logger = LoggerFactory.getLogger(MySQLCleanupListener.class);

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            // Đóng connection pool
            DBConnection.closeDataSource();

            // Cleanup MySQL driver
            AbandonedConnectionCleanupThread.checkedShutdown();

            logger.info("MySQL resources cleaned up successfully");
        } catch (Exception e) {
            logger.error("Error during MySQL cleanup", e);
        }
    }
}