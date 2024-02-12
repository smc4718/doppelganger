package com.doppelganger.schedule;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.doppelganger.service.BlogService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Component
public class BlogImageBatch {

  private final BlogService blogService;
  
  @Scheduled(cron="0 0 1 1/1 * ?")  // 매일 새벽 1시에 동작
  public void execute() {
    blogService.blogImageBatch();
  }
  
}
