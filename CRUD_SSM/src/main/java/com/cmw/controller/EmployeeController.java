package com.cmw.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmw.bean.Employee;
import com.cmw.bean.Msg;
import com.cmw.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工增删改查
 * @author cmw
 * @time 2017年8月23日 下午9:26:52
 */

@Controller	
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	
	/**
	 * 员工删除方法
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids")String ids) {
		//批量删除
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<>();
			String[] str_ids = ids.split("-");	
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		}else {//单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}	
		return Msg.success();
		
	}
	
	
	/**
	 * 员工更新方法
	 * @param employee
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee,HttpServletRequest request) {
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	
	
	/**
	 * 根据id查询员工
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee = employeeService.getEmp(id); 
		return Msg.success().add("emp", employee);
	}
	
	
	/**
	 * 检查用户名是否可用
	 * @param empName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName")String empName){
		//先判断用户名是否合法
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u4e00-\u9fa5]{2,5})";
		if(!empName.matches(regx)){
			return Msg.fail().add("va_msg", "用户名错误：请输入2-5位的中文或6-16位的英文和数字组合!");
		}
		boolean b = employeeService.checkUser(empName);
		if(b){
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "用户名已存在");
		}		
	}
	
	/**
	 * 员工保存
	 * 1、支持JSR303
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		if(result.hasErrors()){
			//检验失败，返回错误信息
			Map<String, Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError fieldError : errors) {
				System.out.println("错误的字段名："+fieldError.getField());
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
	}
	
	/**
	 * 需要引入Jackson包
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn,
			Model model) {
		//引入pageHelper分页插件
				//在查询之前只需要调用，传入页面，以及每页大小
				PageHelper.startPage(pn, 5);
				//startPage后面紧跟的这个查询就是一个分页查询
				List<Employee> emps = employeeService.getAll();
				//使用pageinfo包装查询后的结果，只需要将pageinfo交给页面
				//封装了详细的分页信息，包括查询出来的数据，传入连续显示的页数
				PageInfo page = new PageInfo(emps,5);
				return Msg.success().add("pageInfo", page);
	}
	
	
	/**
	 * 查询员工数据(分页查询)
	 * @return
	 */
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,
			Model model){
		//引入pageHelper分页插件
				//在查询之前只需要调用，传入页面，以及每页大小
				PageHelper.startPage(pn, 5);
				//startPage后面紧跟的这个查询就是一个分页查询
				Employee employee = new Employee();
				List<Employee> emps = employeeService.getAll();
				//使用pageinfo包装查询后的结果，只需要将pageinfo交给页面
				//封装了详细的分页信息，包括查询出来的数据，传入连续显示的页数
				PageInfo page = new PageInfo(emps,5);
				model.addAttribute("pageInfo", page);
		return "list";
	}
}
