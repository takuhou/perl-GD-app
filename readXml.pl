#!/usr/bin/perl

use strict;
use Data::Dumper;
use XML::Simple; 
use Math::Trig;
use GD;

# XML読み込み
my $xml = XML::Simple->new();
my $xref = $xml->XMLin('sample-data/201009031500_09.xml');

#画像作成
my $img = new GD::Image(350, 350);

#//ポーラー図法北極、赤道地点のＸＹ座標
my $P1x = 325;
my $P1y = -386;
my $P2x = 325;
my $P2y = 731;

#/////////////////////////////////////////
#//共通関数ポーラ図法ＸＹ座標算出
sub getXYPos {
  my ($Xv, $Yv) = @_;

  my $Opos = ($P1y*-1);
  my $Ypos = ($P1y*-1)+$P2y;
  my $Xpos = $P1x;
  #//レフレンスポイントの配置・緯度経度をポーラー図法に変換 
  my $H = (-1*$Ypos) * tan(pi/180*(90-$Yv)/2);
  my @rValue;
  $rValue[0] = $H * sin(pi/180*(140-$Xv)) + $Xpos;
  $rValue[1] = -$H * cos(pi/180*(140-$Xv)) - $Opos;
  return @rValue;
}


#my $xml = XML::Simple->new(forcearray => 1);

#print Dumper($xref);
#print Dumper($xref->{'Body'}->{'Live'}->{'Situation'}->{'DateTime'});

# 台風緯度経度情報抽出（実況部）
# 実況部の値取得
my $Live_lat_deg = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'deg'};
my $Live_lat_min = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'min'};
my $Live_lat_sec = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'sec'};

my $Live_lon_deg = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'deg'};
my $Live_lon_min = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'min'};
my $Live_lon_sec = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'sec'};

my $Live_lat = $Lat_deg + $Lat_min/100;
my $Live_lon = $Lon_deg + $Lon_min/100;

#予報部の個数取得
my $Forecast = $xref->{'Body'}->{'Forecast'};

print Dumper($Forecast);



=pod
foreach () {
  my $Next_Lat_deg = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLtd'}->{'deg'};
  my $Next_Lat_min = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLtd'}->{'min'};
  my $Next_Lat_sec = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLtd'}->{'sec'};

  my $Next_Lon_deg = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLng'}->{'deg'};
  my $Next_Lon_min = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLng'}->{'min'};
  my $Next_Lon_sec = $xref->{'Body'}->{'Forecast'}->[0]->{'Situation'}->{'WldLng'}->{'sec'};

  my $Next_Lat = $Next_Lat_deg + $Next_Lat_min/100;
  my $Next_Lon = $Next_Lon_deg + $Next_Lon_min/100;

  my @P = getXYPos($Lon,$Lat);

  my $xP = $P[0];
  my $yP = $P[1];

  my @nP = getXYPos($Next_Lon,$Next_Lat);

  my $nxP = $nP[0];
  my $nyP = $nP[1];

  print($xP, "\n");
  print($yP, "\n");
  print($nxP, "\n");
  print($nxP, "\n");

  my $black = $img->colorAllocate(0, 0, 0);
  my $white = $img->colorAllocate(255, 255, 255);

  # 白を透明色にし、インタレース化する
  $img->transparent($white);
  $img->interlaced('true');

  $img->line($xP, $yP, $nxP, $nyP, $white);
}
=cut


#print Dumper($xref->{'Body'}->{'Live'}->{'Pressure'});
#print Dumper($xref->{'Body'}->{'Forecast'}->[1]);
#print Dumper($xref->{'Body'}->{'Forecast'}->[2]);
#print Dumper($xref->{'Body'}->{'Forecast'});

#$img->line(0, 0, $nxP, $nyP, $white);

#open(OUT, "> gd-test.png");
#binmode(OUT);
#print OUT $img->png;
#close(OUT);