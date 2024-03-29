package com.doppelganger.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class LeaveUserDto {
  private String email;
  private Date joinedAt;
  private Date leavedAt;
}
