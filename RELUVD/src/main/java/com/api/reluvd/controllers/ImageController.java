package com.api.reluvd.controllers;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.nio.file.*;

@RestController
@RequestMapping("/file/image")
public class ImageController {

    @GetMapping("/{folder}/{filename:.+}")
    public ResponseEntity<Resource> serveImage(
            @PathVariable String folder,
            @PathVariable String filename) {

        try {
            Path filePath = Paths.get("C:/reluvd-images").resolve(folder).resolve(filename);
            
            if (!Files.exists(filePath)) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new UrlResource(filePath.toUri());
            String contentType = Files.probeContentType(filePath);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType != null ? contentType : "application/octet-stream"))
                    .body(resource);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}

