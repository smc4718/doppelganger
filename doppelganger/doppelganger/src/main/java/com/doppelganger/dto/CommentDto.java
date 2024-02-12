package com.doppelganger.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class CommentDto {
  private int commentNo;
  private String contents;
  private int blogNo;
  private String createdAt;
  private int status;
  private int depth;
  private int groupNo;
  private UserDto userDto;  // private int userNo;
}
