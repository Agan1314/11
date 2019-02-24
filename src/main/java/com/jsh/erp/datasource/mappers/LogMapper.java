package com.jsh.erp.datasource.mappers;

import com.jsh.erp.datasource.entities.Log;
import com.jsh.erp.datasource.entities.LogExample;
import java.util.List;

import com.jsh.erp.datasource.vo.LogVo4List;
import org.apache.ibatis.annotations.Param;

public interface LogMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int countByExample(LogExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int deleteByExample(LogExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int deleteByPrimaryKey(Long id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int insert(Log record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int insertSelective(Log record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    List<Log> selectByExample(LogExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    Log selectByPrimaryKey(Long id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int updateByExampleSelective(@Param("record") Log record, @Param("example") LogExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int updateByExample(@Param("record") Log record, @Param("example") LogExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int updateByPrimaryKeySelective(Log record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table jsh_log
     *
     * @mbggenerated
     */
    int updateByPrimaryKey(Log record);
}