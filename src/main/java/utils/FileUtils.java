package utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class FileUtils {
    private static final Logger LOGGER = Logger.getLogger(FileUtils.class.getName());

    // Get the absolute path to the file within the web application's data directory
    public static String getFilePath(ServletContext context, String fileName) {
        // Temporary workaround: Use the deployed directory directly
        String deployedPath = "C:\\Users\\ADMIN\\.SmartTomcat\\test\\test\\webapps\\test\\data\\" + fileName;
        File deployedFile = new File(deployedPath);
        if (deployedFile.exists()) {
            LOGGER.info("Using deployed directory path for " + fileName + ": " + deployedPath);
            return deployedPath;
        }

        // Default behavior: Try to resolve using getRealPath
        String path = context.getRealPath("/data/" + fileName);
        if (path == null) {
            LOGGER.warning("ServletContext.getRealPath returned null for /data/" + fileName + ". Attempting to load as resource or create in default directory.");
            try {
                String resourcePath = "/data/" + fileName;
                File tempFile = File.createTempFile("temp-" + fileName, ".txt");
                try (InputStream inputStream = context.getResourceAsStream(resourcePath)) {
                    if (inputStream != null) {
                        try (FileOutputStream outputStream = new FileOutputStream(tempFile)) {
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }
                        }
                        path = tempFile.getAbsolutePath();
                        tempFile.deleteOnExit();
                        LOGGER.info("Loaded file " + fileName + " as resource to temporary path: " + path);
                    } else {
                        LOGGER.warning("Resource not found: " + resourcePath + ". Creating file in default directory.");
                        String defaultDir = System.getProperty("java.io.tmpdir") + File.separator + "webapp_data";
                        File dir = new File(defaultDir);
                        if (!dir.exists()) {
                            dir.mkdirs();
                            LOGGER.info("Created default directory: " + defaultDir);
                        }
                        path = defaultDir + File.separator + fileName;
                        File file = new File(path);
                        if (!file.exists()) {
                            file.createNewFile();
                            LOGGER.info("Created empty file in default directory: " + path);
                        }
                    }
                }
            } catch (IOException e) {
                LOGGER.severe("File path not found and cannot load as resource or create file: /data/" + fileName + " - " + e.getMessage());
                throw new RuntimeException("File path not found and cannot load as resource or create file: /data/" + fileName, e);
            }
        } else {
            LOGGER.info("Resolved file path for " + fileName + ": " + path);
        }
        return path;
    }

    // Write data to the file (append mode)
    public static void writeToFile(ServletContext context, String fileName, String data) throws IOException {
        String filePath = getFilePath(context, fileName);
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, StandardCharsets.UTF_8, true))) {
            writer.write(data);
            writer.newLine();
            LOGGER.info("Appended data to file " + fileName + " at path " + filePath + ": " + data);
        } catch (IOException e) {
            LOGGER.severe("Error appending to file " + fileName + " at path " + filePath + ": " + e.getMessage());
            throw e;
        }
    }

    // Read all lines from the file
    public static List<String> readFromFile(ServletContext context, String fileName) throws IOException {
        List<String> lines = new ArrayList<>();
        String filePath = getFilePath(context, fileName);
        File file = new File(filePath);
        if (!file.exists()) {
            LOGGER.warning("File does not exist: " + filePath + ". Creating an empty file.");
            file.getParentFile().mkdirs();
            file.createNewFile();
            LOGGER.info("Created empty file: " + filePath);
            return lines;
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(file, StandardCharsets.UTF_8))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    lines.add(line);
                    lineNumber++;
                    LOGGER.fine("Read line " + lineNumber + " from " + fileName + ": " + line);
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading file " + fileName + " at path " + filePath + ": " + e.getMessage());
            throw e;
        }
        LOGGER.info("Read " + lines.size() + " non-empty lines from file " + fileName + " at path " + filePath);
        return lines;
    }

    // Rewrite the entire file with updated data (used for update and delete)
    public static void rewriteFile(ServletContext context, String fileName, List<String> data) throws IOException {
        String filePath = getFilePath(context, fileName);
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, StandardCharsets.UTF_8, false))) {
            for (int i = 0; i < data.size(); i++) {
                String line = data.get(i);
                writer.write(line);
                writer.newLine();
                LOGGER.fine("Wrote line " + (i + 1) + " to " + fileName + ": " + line);
            }
        } catch (IOException e) {
            LOGGER.severe("Error rewriting file " + fileName + " at path " + filePath + ": " + e.getMessage());
            throw e;
        }
        LOGGER.info("Rewrote file " + fileName + " at path " + filePath + " with " + data.size() + " lines");
    }

    // Save uploaded image file and return the relative path
    public static String saveImageFile(ServletContext context, String baseDir, Part filePart) throws IOException {
        String uploadDir = context.getRealPath("/data/" + baseDir);
        if (uploadDir == null) {
            LOGGER.severe("Cannot resolve upload directory: /data/" + baseDir + ". Using default directory.");
            uploadDir = System.getProperty("java.io.tmpdir") + File.separator + "webapp_data" + File.separator + baseDir;
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
                LOGGER.info("Created default upload directory: " + uploadDir);
            }
        } else {
            LOGGER.info("Resolved upload directory: " + uploadDir);
        }
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
            LOGGER.info("Created upload directory: " + uploadDir);
        }

        String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
        String filePath = uploadDir + File.separator + fileName;

        try (InputStream input = filePart.getInputStream();
             OutputStream output = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            LOGGER.severe("Error saving image file to " + filePath + ": " + e.getMessage());
            throw e;
        }
        LOGGER.info("Saved image file to " + filePath);

        return baseDir + "/" + fileName;
    }
}