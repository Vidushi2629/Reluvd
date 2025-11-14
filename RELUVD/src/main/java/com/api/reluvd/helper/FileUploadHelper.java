package com.api.reluvd.helper;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUploadHelper {

    public boolean uploadFile(MultipartFile file, String filename, String subDirectory) {
        try {
            // Save files to C:/project-images/subDirectory
            String baseDir = "C:" + File.separator + "reluvd-images";

            Path uploadPath = Paths.get(baseDir, subDirectory);

            // Create directories if not exist
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            Path filePath = uploadPath.resolve(filename);

            // Copy file to target location (overwrite if exists)
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
