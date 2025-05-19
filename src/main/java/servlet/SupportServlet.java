package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SupportRequest;
import utils.FileUtils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;


public class SupportServlet extends HttpServlet {
    private static final String SUPPORT_FILE = "supportRequests.txt";
    private static final String USER_FILE = "users.txt";
    private static final Logger LOGGER = Logger.getLogger(SupportServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to SupportServlet (POST): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("submit".equals(action)) {
            String subject = req.getParameter("subject");
            String message = req.getParameter("message");

            if (subject == null || message == null || subject.trim().isEmpty() || message.trim().isEmpty()) {
                LOGGER.warning("Invalid support request submission attempt by user " + userId + ": Missing required fields.");
                resp.sendRedirect("supportRequest.jsp?error=" + java.net.URLEncoder.encode("Subject and message are required.", "UTF-8"));
                return;
            }

            // Create a support request entry
            String requestId = "SUP" + System.currentTimeMillis();
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            SupportRequest supportRequest = new SupportRequest(requestId, userId, subject, message, timestamp);

            // Save the support request to supportRequests.txt
            try {
                FileUtils.writeToFile(getServletContext(), SUPPORT_FILE, supportRequest.toString());
                LOGGER.info("Support request submitted by user " + userId + ": Request ID " + requestId);
                resp.sendRedirect("supportRequest.jsp?success=" + java.net.URLEncoder.encode("Support request submitted successfully.", "UTF-8"));
            } catch (IOException e) {
                LOGGER.severe("Error saving support request: " + e.getMessage());
                resp.sendRedirect("supportRequest.jsp?error=" + java.net.URLEncoder.encode("Error submitting support request: " + e.getMessage(), "UTF-8"));
            }
        } else {
            LOGGER.info("Unknown POST action in SupportServlet for user " + userId + ": " + action + ", redirecting to supportRequest.jsp");
            resp.sendRedirect("supportRequest.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to SupportServlet (GET): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        if ("manage".equals(action)) {
            if (!"admin".equals(role)) {
                LOGGER.warning("Unauthorized access attempt to manage support requests: User is not an admin. Role: " + role);
                resp.sendRedirect("home.jsp");
                return;
            }

            // Load all support requests
            List<SupportRequest> supportRequests = loadSupportRequests();
            Map<String, String> userNames = loadUserNames();

            req.setAttribute("supportRequests", supportRequests);
            req.setAttribute("userNames", userNames);
            req.getRequestDispatcher("manageSupport.jsp").forward(req, resp);
        } else {
            LOGGER.info("Unknown GET action in SupportServlet: " + action + ", redirecting to home.jsp");
            resp.sendRedirect("home.jsp");
        }
    }

    private List<SupportRequest> loadSupportRequests() {
        List<SupportRequest> supportRequests = new ArrayList<>();
        try {
            List<String> requestData = FileUtils.readFromFile(getServletContext(), SUPPORT_FILE);
            for (String line : requestData) {
                try {
                    supportRequests.add(SupportRequest.fromString(line));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing support request: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading supportRequests.txt: " + e.getMessage());
        }
        return supportRequests;
    }

    private Map<String, String> loadUserNames() {
        Map<String, String> userNames = new HashMap<>();
        try {
            List<String> userData = FileUtils.readFromFile(getServletContext(), USER_FILE);
            for (String line : userData) {
                try {
                    String[] parts = line.split(",");
                    if (parts.length != 8) {
                        throw new IllegalArgumentException("Invalid user format: " + line);
                    }
                    String id = parts[0];
                    String name = parts[1];
                    userNames.put(id, name);
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing user: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading users.txt: " + e.getMessage());
        }
        return userNames;
    }
}