#!/usr/bin/perl
 
use GD;

# 画像を作る
$img = new GD::Image(100, 100);

# 色を定義する
$white = $img->colorAllocate(255, 255, 255);
$black = $img->colorAllocate(0, 0, 0);
$green = $img->colorAllocate(0, 128, 0);

# 白を透明色にし、インタレース化する
$img->transparent($white);
$img->interlaced('true');

# 枠線、円を描き、塗りつぶし、文字を描く
$img->rectangle(0, 0, 99, 99, $black);
$img->arc(50, 50, 50, 50, 0, 360, $green);
$img->fill(50, 50, $green);
$img->string(gdMediumBoldFont, 10, 10, "Hello!!", $black);

# 結果を PNG 形式でファイルに書き出す
open(OUT, "> gd-test.png");
binmode(OUT);
print OUT $img->png;
close(OUT);