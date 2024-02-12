package com.doppelganger.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doppelganger.dto.UploadDto;
import com.doppelganger.service.UploadService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/upload")
@RequiredArgsConstructor
@Controller
public class UploadController {

  private final UploadService uploadService;
  
  @GetMapping("/list.do")
  public String list() {
    return "upload/list";
  }
  
  @GetMapping("/write.form")
  public String write() {
    return "upload/write";
  }
  
  @PostMapping("/add.do")
  public String add(MultipartHttpServletRequest multipartRequest
                  , RedirectAttributes redirectAttributes) throws Exception {
    boolean addResult = uploadService.addUpload(multipartRequest);
    redirectAttributes.addFlashAttribute("addResult", addResult);
    return "redirect:/upload/list.do";
  }
  
  @ResponseBody
  @GetMapping(value="/getList.do", produces="application/json")
  public Map<String, Object> getList(HttpServletRequest request){
    return uploadService.getUploadList(request);
  }
  
  @GetMapping("/detail.do")
  public String detail(HttpServletRequest request, Model model) {
    uploadService.loadUpload(request, model);
    return "upload/detail";
  }
  
  @GetMapping("/download.do")
  public ResponseEntity<Resource> download(HttpServletRequest request) {
    return uploadService.download(request);
  }
  
  @GetMapping("/downloadAll.do")
  public ResponseEntity<Resource> downloadAll(HttpServletRequest request) {
    return uploadService.downloadAll(request);
  }
  
  @GetMapping("/edit.form")
  public String edit(@RequestParam(value="uploadNo", required=false, defaultValue="0") int uploadNo
                   , Model model) {
    model.addAttribute("upload", uploadService.getUpload(uploadNo));
    return "upload/edit";
  }
  
  @PostMapping("/modify.do")
  public String modify(UploadDto upload, RedirectAttributes redirectAttributes) {
    int modifyResult = uploadService.modifyUpload(upload);
    redirectAttributes.addFlashAttribute("modifyResult", modifyResult);
    return "redirect:/upload/detail.do?uploadNo=" + upload.getUploadNo();
  }
  
  @ResponseBody
  @GetMapping(value="/getAttachList.do", produces="application/json")
  public Map<String, Object> getAttachList(HttpServletRequest request) {
    return uploadService.getAttachList(request);
  }
  
  @ResponseBody
  @PostMapping(value="/removeAttach.do", produces="application/json")
  public Map<String, Object> removeAttach(HttpServletRequest request) {
    return uploadService.removeAttach(request);
  }
  
  @ResponseBody
  @PostMapping(value="/addAttach.do", produces="application/json")
  public Map<String, Object> addAttach(MultipartHttpServletRequest multipartRequest) throws Exception {
    return uploadService.addAttach(multipartRequest);
  }
  
  @PostMapping("/removeUpload.do")
  public String removeUpload(@RequestParam(value="uploadNo", required=false, defaultValue="0") int uploadNo
                           , RedirectAttributes redirectAttributes) {
    int removeResult = uploadService.removeUpload(uploadNo);
    redirectAttributes.addFlashAttribute("removeResult", removeResult);
    return "redirect:/upload/list.do";
  }
  
}
