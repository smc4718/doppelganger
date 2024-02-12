package com.doppelganger.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface FreeService {
  public int addFree(HttpServletRequest request);
  public void loadFreeList(HttpServletRequest request, Model model);
  public int addReply(HttpServletRequest request);
  public int removeFree(int freeNo);
  public void loadSearchList(HttpServletRequest request, Model model);
}
