package com.doppelganger.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.doppelganger.dto.UploadDto;

public interface UploadService {
  public boolean addUpload(MultipartHttpServletRequest multipartRequest) throws Exception;
  public Map<String, Object> getUploadList(HttpServletRequest request);
  public void loadUpload(HttpServletRequest request, Model model);
  public ResponseEntity<Resource> download(HttpServletRequest request);
  public ResponseEntity<Resource> downloadAll(HttpServletRequest request);
  public void removeTempFiles();
  public UploadDto getUpload(int uploadNo);
  public int modifyUpload(UploadDto upload);
  public Map<String, Object> getAttachList(HttpServletRequest request);
  public Map<String, Object> removeAttach(HttpServletRequest request);
  public Map<String, Object> addAttach(MultipartHttpServletRequest multipartRequest) throws Exception;
  public int removeUpload(int uploadNo);
}