package com.doppelganger.service;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.doppelganger.dao.UploadMapper;
import com.doppelganger.dto.AttachDto;
import com.doppelganger.dto.UploadDto;
import com.doppelganger.dto.UserDto;
import com.doppelganger.util.MyFileUtils;
import com.doppelganger.util.MyPageUtils;

import lombok.RequiredArgsConstructor;
import net.coobird.thumbnailator.Thumbnails;

@Transactional
@RequiredArgsConstructor
@Service
public class UploadServiceImpl implements UploadService {

  private final UploadMapper uploadMapper;
  private final MyFileUtils myFileUtils;
  private final MyPageUtils myPageUtils;
  
  @Override
  public boolean addUpload(MultipartHttpServletRequest multipartRequest) throws Exception {
    
    String title = multipartRequest.getParameter("title");
    String contents = multipartRequest.getParameter("contents");
    int userNo = Integer.parseInt(multipartRequest.getParameter("userNo"));
    
    UploadDto upload = UploadDto.builder()
                        .title(title)
                        .contents(contents)
                        .userDto(UserDto.builder()
                                  .userNo(userNo)
                                  .build())
                        .build();
    
    int uploadCount = uploadMapper.insertUpload(upload);
    
    List<MultipartFile> files = multipartRequest.getFiles("files");
    
    // 첨부 없을 때 : [MultipartFile[field="files", filename=, contentType=application/octet-stream, size=0]]
    // 첨부 1개     : [MultipartFile[field="files", filename="animal1.jpg", contentType=image/jpeg, size=123456]]
    
    int attachCount;
    if(files.get(0).getSize() == 0) {
      attachCount = 1;
    } else {
      attachCount = 0;
    }
    
    for(MultipartFile multipartFile : files) {
      
      if(multipartFile != null && !multipartFile.isEmpty()) {
        
        String path = myFileUtils.getUploadPath();
        File dir = new File(path);
        if(!dir.exists()) {
          dir.mkdirs();
        }
        
        String originalFilename = multipartFile.getOriginalFilename();
        String filesystemName = myFileUtils.getFilesystemName(originalFilename);
        File file = new File(dir, filesystemName);
        
        multipartFile.transferTo(file);
        
        String contentType = Files.probeContentType(file.toPath());  // 이미지의 Content-Type은 image/jpeg, image/png 등 image로 시작한다.
        int hasThumbnail = (contentType != null && contentType.startsWith("image")) ? 1 : 0;
        
        if(hasThumbnail == 1) {
          File thumbnail = new File(dir, "s_" + filesystemName);  // small 이미지를 의미하는 s_을 덧붙임
          Thumbnails.of(file)
                    .size(100, 100)      // 가로 100px, 세로 100px
                    .toFile(thumbnail);
        }
        
        AttachDto attach = AttachDto.builder()
                            .path(path)
                            .originalFilename(originalFilename)
                            .filesystemName(filesystemName)
                            .hasThumbnail(hasThumbnail)
                            .uploadNo(upload.getUploadNo())
                            .build();
        
        attachCount += uploadMapper.insertAttach(attach);
        
      }  // if
      
    }  // for
    
    return (uploadCount == 1) && (files.size() == attachCount);
    
  }
  
  @Transactional(readOnly=true)
  @Override
  public Map<String, Object> getUploadList(HttpServletRequest request) {
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(opt.orElse("1"));
    int total = uploadMapper.getUploadCount();
    int display = 9;
    
    myPageUtils.setPaging(page, total, display);
    
    Map<String, Object> map = Map.of("begin", myPageUtils.getBegin()
                                   , "end", myPageUtils.getEnd());
    
    List<UploadDto> uploadList = uploadMapper.getUploadList(map);
    
    return Map.of("uploadList", uploadList
                , "totalPage", myPageUtils.getTotalPage());
    
  }
  
  @Transactional(readOnly=true)
  @Override
  public void loadUpload(HttpServletRequest request, Model model) {
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("uploadNo"));
    int uploadNo = Integer.parseInt(opt.orElse("0"));
    
    model.addAttribute("upload", uploadMapper.getUpload(uploadNo));
    model.addAttribute("attachList", uploadMapper.getAttachList(uploadNo));
    
  }
  
  @Override
  public ResponseEntity<Resource> download(HttpServletRequest request) {
    
    // 첨부 파일의 정보 가져오기
    int attachNo = Integer.parseInt(request.getParameter("attachNo"));
    AttachDto attach = uploadMapper.getAttach(attachNo);
    
    // 첨부 파일 File 객체 -> Resource 객체
    File file = new File(attach.getPath(), attach.getFilesystemName());
    Resource resource = new FileSystemResource(file);
    
    // 첨부 파일이 없으면 다운로드 취소
    if(!resource.exists()) {
      return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
    }
    
    // 다운로드 횟수 증가하기
    uploadMapper.updateDownloadCount(attachNo);
    
    // 사용자가 다운로드 받을 파일의 이름 결정 (User-Agent값에 따른 인코딩 처리)
    String originalFilename = attach.getOriginalFilename();
    String userAgent = request.getHeader("User-Agent");
    try {
      // IE
      if(userAgent.contains("Trident")) {
        originalFilename = URLEncoder.encode(originalFilename, "UTF-8").replace("+", " ");
      }
      // Edge
      else if(userAgent.contains("Edg")) {
        originalFilename = URLEncoder.encode(originalFilename, "UTF-8");
      }
      // Other
      else {
        originalFilename = new String(originalFilename.getBytes("UTF-8"), "ISO-8859-1");
      }
    } catch(Exception e) {
      e.printStackTrace();
    }
    
    // 다운로드 응답 헤더 만들기
    HttpHeaders header = new HttpHeaders();
    header.add("Content-Type", "application/octet-stream");
    header.add("Content-Disposition", "attachment; filename=" + originalFilename);
    header.add("Content-Length", file.length() + "");
    
    // 응답
    return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    
  }
  
  @Override
  public ResponseEntity<Resource> downloadAll(HttpServletRequest request) {
    
    // 다운로드 할 모든 첨부 파일 정보 가져오기
    int uploadNo = Integer.parseInt(request.getParameter("uploadNo"));
    List<AttachDto> attachList = uploadMapper.getAttachList(uploadNo);
    
    // 첨부 파일이 없으면 종료
    if(attachList.isEmpty()) {
      return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
    }
    
    // zip 파일을 생성할 경로
    File tempDir = new File(myFileUtils.getTempPath());
    if(!tempDir.exists()) {
      tempDir.mkdirs();
    }
    
    // zip 파일의 이름
    String zipName = myFileUtils.getTempFilename() + ".zip";
    
    // zip 파일의 File 객체
    File zipFile = new File(tempDir, zipName);
    
    // zip 파일을 생성하는 출력 스트림
    ZipOutputStream zout = null;
    
    // 첨부 파일들을 순회하면서 zip 파일에 등록하기
    try {
      
      zout = new ZipOutputStream(new FileOutputStream(zipFile));
      
      for(AttachDto attach : attachList) {
        
        // 각 첨부 파일들의 원래 이름으로 zip 파일에 등록하기 (이름만 등록)
        ZipEntry zipEntry = new ZipEntry(attach.getOriginalFilename());
        zout.putNextEntry(zipEntry);
        
        // 각 첨부 파일들의 내용을 zip 파일에 등록하기 (실제 파일 등록)
        BufferedInputStream bin = new BufferedInputStream(new FileInputStream(new File(attach.getPath(), attach.getFilesystemName())));
        zout.write(bin.readAllBytes());
        
        // 자원 반납
        bin.close();
        zout.closeEntry();
        
        // 다운로드 횟수 증가
        uploadMapper.updateDownloadCount(attach.getAttachNo());
        
      }
      
      // zout 자원 반납
      zout.close();
      
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    // 다운로드할 zip 파일의 File 객체 -> Resource 객체
    Resource resource = new FileSystemResource(zipFile);
    
    // 다운로드 응답 헤더 만들기
    HttpHeaders header = new HttpHeaders();
    header.add("Content-Type", "application/octet-stream");
    header.add("Content-Disposition", "attachment; filename=" + zipName);
    header.add("Content-Length", zipFile.length() + "");
    
    // 응답
    return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    
  }
  
  @Override
  public void removeTempFiles() {
    File tempDir = new File(myFileUtils.getTempPath());
    File[] targetList = tempDir.listFiles();
    if(targetList != null) {
      for(File target : targetList) {
        target.delete();
      }
    }
  }
  
  @Transactional(readOnly=true)
  @Override
  public UploadDto getUpload(int uploadNo) {
    return uploadMapper.getUpload(uploadNo);
  }
  
  @Override
  public int modifyUpload(UploadDto upload) {
    return uploadMapper.updateUpload(upload);
  }
  
  @Override
  public Map<String, Object> getAttachList(HttpServletRequest request) {
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("uploadNo"));
    int uploadNo = Integer.parseInt(opt.orElse("0"));
    
    return Map.of("attachList", uploadMapper.getAttachList(uploadNo));
    
  }
  
  @Override
  public Map<String, Object> removeAttach(HttpServletRequest request) {
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("attachNo"));
    int attachNo = Integer.parseInt(opt.orElse("0"));
    
    // 파일 삭제
    AttachDto attach = uploadMapper.getAttach(attachNo);
    File file = new File(attach.getPath(), attach.getFilesystemName());
    if(file.exists()) {
      file.delete();
    }
    
    // 썸네일 삭제
    if(attach.getHasThumbnail() == 1) {
      File thumbnail = new File(attach.getPath(), "s_" + attach.getFilesystemName());
      if(thumbnail.exists()) {
        thumbnail.delete();
      }
    }
    
    // ATTACH_T 삭제
    int removeResult = uploadMapper.deleteAttach(attachNo);
    
    return Map.of("removeResult", removeResult);
    
  }
  
  @Override
  public Map<String, Object> addAttach(MultipartHttpServletRequest multipartRequest) throws Exception {
    
    List<MultipartFile> files =  multipartRequest.getFiles("files");
    
    int attachCount;
    if(files.get(0).getSize() == 0) {
      attachCount = 1;
    } else {
      attachCount = 0;
    }
    
    for(MultipartFile multipartFile : files) {
      
      if(multipartFile != null && !multipartFile.isEmpty()) {
        
        String path = myFileUtils.getUploadPath();
        File dir = new File(path);
        if(!dir.exists()) {
          dir.mkdirs();
        }
        
        String originalFilename = multipartFile.getOriginalFilename();
        String filesystemName = myFileUtils.getFilesystemName(originalFilename);
        File file = new File(dir, filesystemName);
        
        multipartFile.transferTo(file);
        
        String contentType = Files.probeContentType(file.toPath());  // 이미지의 Content-Type은 image/jpeg, image/png 등 image로 시작한다.
        int hasThumbnail = (contentType != null && contentType.startsWith("image")) ? 1 : 0;
        
        if(hasThumbnail == 1) {
          File thumbnail = new File(dir, "s_" + filesystemName);  // small 이미지를 의미하는 s_을 덧붙임
          Thumbnails.of(file)
                    .size(100, 100)      // 가로 100px, 세로 100px
                    .toFile(thumbnail);
        }
        
        AttachDto attach = AttachDto.builder()
                            .path(path)
                            .originalFilename(originalFilename)
                            .filesystemName(filesystemName)
                            .hasThumbnail(hasThumbnail)
                            .uploadNo(Integer.parseInt(multipartRequest.getParameter("uploadNo")))
                            .build();
        
        attachCount += uploadMapper.insertAttach(attach);
        
      }  // if
      
    }  // for
    
    return Map.of("attachResult", files.size() == attachCount);
    
  }
  
  @Override
  public int removeUpload(int uploadNo) {
    
    // 파일 삭제
    List<AttachDto> attachList = uploadMapper.getAttachList(uploadNo);
    for(AttachDto attach : attachList) {
      
      File file = new File(attach.getPath(), attach.getFilesystemName());
      if(file.exists()) {
        file.delete();
      }
      
      if(attach.getHasThumbnail() == 1) {
        File thumbnail = new File(attach.getPath(), "s_" + attach.getFilesystemName());
        if(thumbnail.exists()) {
          thumbnail.delete();
        }
      }
      
    }
    
    // UPLOAD_T 삭제
    return uploadMapper.deleteUpload(uploadNo);
    
  }
  
}
