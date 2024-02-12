package com.doppelganger.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class FreeDto {
  private int freeNo;
  private String email;
  private String contents;
  private Timestamp createdAt;
  private int status;
  private int depth;
  private int groupNo;
  private int groupOrder;
}
