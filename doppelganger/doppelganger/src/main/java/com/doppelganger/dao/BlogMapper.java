package com.doppelganger.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.doppelganger.dto.BlogDto;
import com.doppelganger.dto.BlogImageDto;
import com.doppelganger.dto.CommentDto;

@Mapper
public interface BlogMapper {
  public int insertBlog(BlogDto blog);
  public int insertBlogImage(BlogImageDto blogImage);
  public List<BlogImageDto> getBlogImageInYesterday();
  public int getBlogCount();
  public List<BlogDto> getBlogList(Map<String, Object> map);
  public int updateHit(int blogNo);
  public BlogDto getBlog(int blogNo);
  public int updateBlog(BlogDto blog);
  public List<BlogImageDto> getBlogImageList(int blogNo);
  public int deleteBlogImage(String filesystemName);
  public int deleteBlogImageList(int blogNo);
  public int deleteBlog(int blogNo);
  
  public int insertComment(CommentDto comment);
  public int getCommentCount(int blogNo);
  public List<CommentDto> getCommentList(Map<String, Object> map);
  public int insertCommentReply(CommentDto comment);
  public int deleteComment(int commentNo);
}
