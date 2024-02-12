package com.doppelganger.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class BlogImageDto {
  private int blogNo;
  private String imagePath; 
  private String filesystemName;
}
