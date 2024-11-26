package org.example.chatapp2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.util.Base64;
import java.util.UUID;

@WebServlet("/camera")
@MultipartConfig
public class CameraServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/camera.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Retrieve the base64 image data from the request
        String imageData = request.getParameter("imageData");

        if (imageData != null && !imageData.isEmpty()) {
            // Decode the base64 string to byte array
            String base64Image = imageData.split(",")[1];
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);

            // Generate a unique file name
            String fileName = UUID.randomUUID() + ".png";
            String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDirFile = new File(uploadDir);

            // Create the upload directory if it does not exist
            if (!uploadDirFile.exists()) {
                boolean created = uploadDirFile.mkdirs(); // Using mkdirs() to create parent directories if necessary
                if (!created) {
                    // Log or handle failure if needed
                    System.err.println("Failed to create upload directory.");
                }
            }

            // Save the file to the upload directory
            File file = new File(uploadDir, fileName);
            try (FileOutputStream outputStream = new FileOutputStream(file)) {
                outputStream.write(imageBytes);
            }

            // Optionally, handle further processing or database storage of the file info here

            // Redirect back to chat.jsp or wherever needed
            String receiver = request.getParameter("receiver");
            response.sendRedirect("chat.jsp?username=" + receiver);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No image data received.");
        }
    }
}
