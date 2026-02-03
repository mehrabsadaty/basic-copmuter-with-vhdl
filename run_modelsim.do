# ========================================
# ModelSim DO Script for Mano CPU Test
# ========================================

# پاک کردن قبلی
quit -sim
.main clear

# ایجاد کتابخانه کار
vlib work
vmap work work

# کامپایل همه فایل‌ها
vcom -2008 -work work memory.vhd
vcom -2008 -work work Address_register.vhd
vcom -2008 -work work Data_register.vhd
vcom -2008 -work work Instruction_register.vhd
vcom -2008 -work work Temporary_register.vhd
vcom -2008 -work work Program_counter.vhd
vcom -2008 -work work ALU.vhd
vcom -2008 -work work data_bus.vhd
vcom -2008 -work work ControlUnit_Mano.vhd
vcom -2008 -work work cpu_top.vhd

# کامپایل تست‌بنچ
vcom -2008 -work work comprehensive_mano_test.vhd

# لود کردن شبیه‌ساز
vsim -voptargs="+acc" work.comprehensive_mano_test

# اضافه کردن همه سیگنال‌ها به پنجره waveform
add wave -position insertpoint sim:/comprehensive_mano_test/*

# تنظیم فرمت نمایش
wave zoom full
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

# اجرای شبیه‌سازی
run 50000 ns

# ذخیره waveform
write wave wave.do

# نمایش پیام پایان
echo "========================================"
echo "Simulation completed!"
echo "Waveform saved to wave.do"
echo "========================================"