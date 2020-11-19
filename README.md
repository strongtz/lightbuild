# light-build(v1.0)

light-build是一个基于kbuild重构融合的完整编译框架，特性如下：

1. 递归混杂多项目编译，通过递归规则一个父可以生成多个子项目
2. 自定义输出路径
3. 多种kconfig配置系统，可以自定义配置文件位置
4. 多种代码错误检查工具

### 编译方法

```bash
make 
make O=/path/			#定义输出路径
make V=1				#显示编译过程
make W=1				#开启编译提示
make -j16				#多线程编译
```

### 编译规则

INCLUDE += abc.包含头文件



### 联系方式

QQ ：1512819690