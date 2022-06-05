--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.PWM;  use RP.PWM;
with RP.SPI;  use RP.SPI;
with RP;      use RP;
with RP.PIO.WS2812;
with RP.Device;
with RP.Timer;
with RP.Clock;
--  with SSD1306;

package Macropad is
   USBBOOT  : aliased GPIO_Point := (Pin => 0);
   --  GP (1 .. 12)
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

   --  The SH1106 display uses the same protocol as SSD1306
   OLED_Width  : constant := 128;
   OLED_Height : constant := 64;
   OLED_SPI    : SPI_Port renames RP.Device.SPI_1;
   --  TODO: The SSD1306 package only supports I2C, but this board uses 4-wire SPI
   --  OLED : SSD1306.SSD1306_Screen
   --     (Buffer_Size_In_Byte => (OLED_Width * OLED_Height) / 8,
   --      Width  => OLED_Width,
   --      Height => OLED_Height,
   --      Port   => RP.Device.SPI_0'Access,
   --      RST    => OLED_RST'Access,
   --      Time   => RP.Device.Timer'Access);

   XOSC_Frequency     : constant RP.Clock.XOSC_Hertz  := 12_000_000;
   XOSC_Startup_Delay : constant RP.Clock.XOSC_Cycles := 768_000;

   Delays : RP.Timer.Delays renames RP.Device.Timer;

   procedure Initialize;

   type Key is range 1 .. 12;
   type Key_State is (Up, Down);
   type Key_States is array (Key) of Key_State;
   GP : array (Key) of aliased GPIO_Point;

   function Status
      return Key_States;

   procedure Note_On
      (Frequency : Hertz := 200)
   with Pre => Frequency in 200 .. 20_000;

   procedure Note_Off;

end Macropad;
