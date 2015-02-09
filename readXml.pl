#!/usr/bin/perl

use strict;
use Data::Dumper;
use XML::Simple; 
use Math::Trig;
use GD;

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
my $xml = XML::Simple->new();

my $xref = $xml->XMLin('sample-data/201009031500_09.xml');

#print Dumper($xref);

#print Dumper($xref->{'Body'}->{'Live'}->{'Situation'}->{'DateTime'});

my $Lat_deg = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'deg'};
my $Lat_min = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'min'};
my $Lat_sec = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLtd'}->{'sec'};

my $Lon_deg = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'deg'};
my $Lon_min = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'min'};
my $Lon_sec = $xref->{'Body'}->{'Live'}->{'Situation'}->{'WldLng'}->{'sec'};

my $Lat = $Lat_deg + $Lat_min/100;
my $Lon = $Lon_deg + $Lon_min/100;

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

#print Dumper($xref->{'Body'}->{'Live'}->{'Pressure'});
#print Dumper($xref->{'Body'}->{'Forecast'}->[1]);
#print Dumper($xref->{'Body'}->{'Forecast'}->[2]);
#print Dumper($xref->{'Body'}->{'Forecast'});

my $black = $img->colorAllocate(0, 0, 0);
my $white = $img->colorAllocate(255, 255, 255);

# 白を透明色にし、インタレース化する
$img->transparent($white);
$img->interlaced('true');

$img->line($xP, $yP, $nxP, $nyP, $white);
#$img->line(0, 0, $nxP, $nyP, $white);

open(OUT, "> gd-test.png");
binmode(OUT);
print OUT $img->png;
close(OUT);