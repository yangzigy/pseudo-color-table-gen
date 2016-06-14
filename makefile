#
# 约束：即使在不同目录下、具有不同扩展名，也不允许出现同名源文件
# 可执行文件
exe   := color.exe
all : $(exe)	#第一个目标
# 源文件目录
src_dir   := .
#src_dir   += .

# obj 目录
obj_dir  := ./obj
MAKE_OBJECT_DIR := $(shell mkdir -p $(obj_dir))

# 包含与库路径
lib_path = .
inc_path = .

# CPP compile flag
cpp_flag := $(addprefix -I,$(wildcard $(inc_path)))
# cpp_flag += -I$(inc_path) -g 
cpp_flag += -std=c++11 -g

c_flag := $(addprefix -I,$(wildcard $(inc_path)))
# c_flag := -I$(inc_path) -g
c_flag += -g

# The library and the link options ( C and C++ common).
ld_flag   := -L$(lib_path) -pthread
ld_flag   +=

cc    = gcc
cxx   = g++

# 对于每一个源文件夹，展开所有的源文件
src_cpp := $(foreach d,$(src_dir),$(wildcard $(d)/*.cpp))
src_c := $(foreach d,$(src_dir),$(wildcard $(d)/*.c))

# 新增单个源文件
src_cpp += 
src_c   +=

# 将.cpp、.c分别替换成.o
objcpp_t1    := $(patsubst %.cpp,%.o,$(src_cpp))
objc_t1    := $(patsubst %.c,%.o,$(src_c))
objcpp_t2    := $(foreach d,$(objcpp_t1),$(notdir $(d)))
objc_t2    := $(foreach d,$(objc_t1),$(notdir $(d)))
objcpp := $(addprefix $(obj_dir)/,$(objcpp_t2))	#加前缀
objc := $(addprefix $(obj_dir)/,$(objc_t2))

# 生成依赖
objall := $(objcpp)
objall += $(objc)
DEPS    = $(patsubst %.o,%.d,$(objall))
# 包含头文件依赖，但必须放在第一个目标后边
-include $(DEPS)
# Rules for producing the executable.
$(exe) : $(objall)
	$(cxx) -o $(exe) $(objall) $(ld_flag)
	ctags -R .

# compile 将.o替换为.cpp，在每个源目录中查找对应的cpp文件
# 注意必须使用= 不能使用:=，才能让循环中每次重新查找cpp文件
compile_cpp_file = $(filter %/$(patsubst %.o,%.cpp,$(notdir $@)),$(src_cpp))
compile_c_file = $(filter %/$(patsubst %.o,%.c,$(notdir $@)),$(src_c))

$(objcpp)	:	%.o	:	$(filter %/$(patsubst %.o,%.cpp,$(notdir %)),$(src_cpp))
	$(cxx) -o $@ -c $(compile_cpp_file) -MMD $(cpp_flag) 
$(objc)	:	%.o	:	$(filter %/$(patsubst %.o,%.c,$(notdir %)),$(src_c))
	$(cc) -o $@ -c $(compile_c_file) -MMD $(c_flag) 

.PHONY : clean all cleanall rebuild
rebuild: clean all
clean :
	rm -f $(objcpp) $(objc) $(DEPS) $(exe)

