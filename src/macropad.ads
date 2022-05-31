--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.PWM; use RP.PWM;
with RP; use RP;
with RP.PIO.WS2812;
with RP.Device;
with RP.Clock;

package Macropad is
   USBBOOT  : aliased GPIO_Point := (Pin => 0);
   GP1      : aliased GPIO_Point := (Pin => 1);
   GP2      : aliased GPIO_Point := (Pin => 2);
   GP3      : aliased GPIO_Point := (Pin => 3);
   GP4      : aliased GPIO_Point := (Pin => 4);
   GP5      : aliased GPIO_Point := (Pin => 5);
   GP6      : aliased GPIO_Point := (Pin => 6);
   GP7      : aliased GPIO_Point := (Pin => 7);
   GP8      : aliased GPIO_Point := (Pin => 8);
   GP9      : aliased GPIO_Point := (Pin => 9);
   GP10     : aliased GPIO_Point := (Pin => 10);
   GP11     : aliased GPIO_Point := (Pin => 11);
   GP12     : aliased GPIO_Point := (Pin => 12);
   LED      : aliased GPIO_Point := (Pin => 13);
   SPKR_SD  : aliased GPIO_Point := (Pin => 14);

   SPEAKER  : aliased GPIO_Point := (Pin => 16);
   ROTA     : aliased GPIO_Point := (Pin => 17);
   ROTB     : aliased GPIO_Point := (Pin => 18);
   NEOPIX   : aliased GPIO_Point := (Pin => 19);
   SDA      : aliased GPIO_Point := (Pin => 20);
   SCL      : aliased GPIO_Point := (Pin => 21);
   OLED_CS  : aliased GPIO_Point := (Pin => 22);
   OLED_RST : aliased GPIO_Point := (Pin => 23);
   OLED_DC  : aliased GPIO_Point := (Pin => 24);

   SCK      : aliased GPIO_Point := (Pin => 26);
   MOSI     : aliased GPIO_Point := (Pin => 27);
   MISO     : aliased GPIO_Point := (Pin => 28);

   Neopixel : aliased RP.PIO.WS2812.Strip
      (Pin => NEOPIX'Access,
       PIO => RP.Device.PIO_0'Access,
       SM  => 0,
       Number_Of_LEDs => 12);

   SPKR_PWM : constant PWM_Point := To_PWM (SPEAKER);

   XOSC_Frequency     : constant RP.Clock.XOSC_Hertz  := 12_000_000;
   XOSC_Startup_Delay : constant RP.Clock.XOSC_Cycles := 768_000;

   procedure Initialize;

   procedure Beep
      (Frequency    : Hertz := 300;
       Milliseconds : Positive := 100)
   with Pre => Frequency in 200 .. 20_000;

end Macropad;
