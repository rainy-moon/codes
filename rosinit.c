#include"ros.h"

//屏幕 sc->maxxxsc->maxy
//存放软盘2e0处
void MAIN(){
	//重新初始化全局描述符表和中断描述符表
	struct GDT_SEG* gs  = (struct GDT_SEG*)0x00500000;
	struct IDT_INTGATE* ii = (struct IDT_INTGATE*)0x00510000;
	for(int i = 0;i<8192;i++)
		set_gdt_segment(gs+i,0,0,0,0);
	for(int i = 0;i<256;i++)
		set_idt_segment(ii+i,0,0,0);
	set_gdt_segment(gs+1,0xffffffff,0,(char)0x92,1);
	set_gdt_segment(gs+2,0x000fffff,0x00101000,(char)0x9a,1);

	set_idt_segment(ii+0x20,(int)asm_inthandler20h-0x101000,2<<3,AR_INTGATE32);
	set_idt_segment(ii+0x21,(int)asm_inthandler21h-0x101000,2<<3,AR_INTGATE32);
	set_idt_segment(ii+0x27,(int)asm_inthandler27h-0x101000,2<<3,AR_INTGATE32);
	set_idt_segment(ii+0x2c,(int)asm_inthandler2ch-0x101000,2<<3,AR_INTGATE32);
	load_gdt(0xffff,0x00500000);
	load_idt(0x07ff,0x00510000);
	init_PIC();
	init_PIT();
	//初始化io缓冲区
	init_io_buffer(&kb_buffer_ctrl,64,kb_buffer);
	init_io_buffer(&ms_buffer_ctrl,128,ms_buffer);
	//初始化鼠标
	init_keyboard();
	enable_mouse();
	sti();
	//开中断
	io_out8(PIC0_IMR, 0xf8); 
	io_out8(PIC1_IMR, 0xef);
	

	//初始化页表
	init_page_ctrl();
	//初始化调色板
	init_color_plate();
	//初始化图层
	init_sheet_ctrl();
	//初始化屏幕图层记录map
	unsigned char* *tp = (unsigned char**)0xffc;
	screen = *tp;
	init_screen_buf();
	//显示鼠标
	mouse_create();
	//桌面图层
	win_create("ROS_desktop",0,0,sc->maxx,sc->maxy,sc->top,6,0);
	//调试窗口
	win_create("debug",200,100,500,400,sc->top,0,1);
	
	
	
	
	mouse.x=0;mouse.y=0;
	mouse.ms_state=0;
	mouse.posx = 160;mouse.posy=100;
	while(1) {
		my_sprintf(s,"%d",time_count);
		win_showslr(2,s,COLOR_BLACK);
		// int length = g_shows(sc->sheets[windows[2].sheet_index].buf,s,windows[2].cursor_x,windows[2].cursor_y,COLOR_BLACK,windows[2].width);
		// sheet_refresh(windows[2].sheet_index,windows[2].cursor_x,windows[2].cursor_y,length*8,16);
		cli();
		get_keyboard_input();
		mouse.ms_state = get_mouse_input(mouse.ms_state);
		stihlt();
	}
	return;
}
#include"system.c"
#include"graphAfont.c"
#include"windows.c"
#include"libc.c"
#include"memory.c"
#include"simlist.c"