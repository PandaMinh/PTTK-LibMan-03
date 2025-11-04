package util;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Configure dotenv to ignore missing .env files so the application can
    // also run when environment variables are provided by the container/server.
    private static final Dotenv dotenv = Dotenv.configure()
            .ignoreIfMissing()
            .load();

    private static final String URL = getEnv("JDBC_URL");
    private static final String USER = getEnv("JDBC_USER");
    private static final String PASSWORD = getEnv("JDBC_PASS");

    private static String getEnv(String key) {
        String value = null;
        try {
            value = dotenv.get(key);
        } catch (Exception e) {
            // ignore and fallback to system env
        }
        if (value == null || value.isEmpty()) {
            value = System.getenv(key);
        }
        return value;
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        // Debug: print which JDBC URL and user we will use (do NOT print password)
        try {
            System.out.println("DBUtil init -> JDBC_URL=" + (URL == null ? "<null>" : URL) + ", JDBC_USER=" + (USER == null ? "<null>" : USER));
        } catch (Throwable t) {
            // ignore any unexpected error in debug logging
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
