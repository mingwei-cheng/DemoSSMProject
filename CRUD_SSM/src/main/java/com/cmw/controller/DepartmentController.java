package com.cmw.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmw.bean.Department;
import com.cmw.bean.Msg;
import com.cmw.service.DepartmentService;

/**
 * 处理和部门有关的请求
 * @author cmw
 * @time 2017年8月25日 下午6:17:27
 */
@Controller
public class DepartmentController {

	@Autowired
	private DepartmentService departmentService;
	/**
	 * 返回所有部门信息
	 * @return
	 */
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts() {
		//查到的所有部门信息
		List<Department> list = departmentService.getDepts();
		return Msg.success().add("depts", list);
	}

}
