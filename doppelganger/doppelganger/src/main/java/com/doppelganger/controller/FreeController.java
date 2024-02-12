package com.doppelganger.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doppelganger.service.FreeService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/free")
@RequiredArgsConstructor
@Controller
public class FreeController {

  private final FreeService freeService;
  
  @GetMapping("/write.form")
  public String writeForm() {
    return "free/write";
  }
  
  @PostMapping("/add.do")
  public String add(HttpServletRequest request, RedirectAttributes redirectAttributes) {
    int addResult = freeService.addFree(request);
    redirectAttributes.addFlashAttribute("addResult", addResult);
    return "redirect:/free/list.do";
  }
  
  @GetMapping("/list.do")
  public String list(HttpServletRequest request, Model model) {
    freeService.loadFreeList(request, model);
    return "free/list";
  }
  
  @PostMapping("/addReply.do")
  public String addReply(HttpServletRequest request, RedirectAttributes redirectAttributes) {
    int addReplyResult = freeService.addReply(request);
    redirectAttributes.addFlashAttribute("addReplyResult", addReplyResult);
    return "redirect:/free/list.do";
  }
  
  @PostMapping("/remove.do")
  public String remove(@RequestParam(value="freeNo") int freeNo, RedirectAttributes redirectAttributes) {
    int removeResult = freeService.removeFree(freeNo);
    redirectAttributes.addFlashAttribute("removeResult", removeResult);
    return "redirect:/free/list.do";
  }
  
  @GetMapping("/search.do")
  public String search(HttpServletRequest request, Model model) {
    freeService.loadSearchList(request, model);
    return "free/list";
  }
  
}