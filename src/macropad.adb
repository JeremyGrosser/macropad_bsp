--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;

package body Macropad is
   PWM_Frequency : constant Hertz := 10_000_000;

   procedure Initialize is
   begin
      RP.Clock.Initialize (XOSC_Frequency, XOSC_Startup_Delay);
      RP.Device.Timer.Enable;

      NEOPIX.Configure (Output, Floating, Neopixel.PIO.all.GPIO_Function);
      Neopixel.Initialize;

      SPKR_SD.Configure (Output, Floating);
      SPKR_SD.Clear;
      SPEAKER.Configure (Output, Floating, RP.GPIO.PWM);

      RP.PWM.Initialize;
      Set_Mode (SPKR_PWM.Slice, Free_Running);
      Set_Frequency (SPKR_PWM.Slice, PWM_Frequency);
      Enable (SPKR_PWM.Slice);

      OLED_RST.Configure (Output, Pull_Up);
      OLED_RST.Clear;
      OLED_DC.Configure (Output, Pull_Up);
      OLED_CS.Configure (Output, Pull_Up, RP.GPIO.SPI);
      SCK.Configure (Output, Pull_Up, RP.GPIO.SPI);
      MOSI.Configure (Output, Floating, RP.GPIO.SPI);
      MISO.Configure (Output, Floating, RP.GPIO.SPI);
      --  OLED_SPI.Configure
      --     ((Role      => Master,
      --       Baud      => 2_000_000,
      --       Data_Size => HAL.SPI.Data_Size_8b,
      --       Polarity  => Active_High,
      --       Phase     => Rising_Edge,
      --       Blocking  => True,
      --       Loopback  => False));
      --  OLED.Initialize (External_VCC => False);
   end Initialize;

   procedure Beep
      (Frequency    : Hertz := 300;
       Milliseconds : Positive := 100)
   is
      Interval : constant Period := Period (PWM_Frequency / Frequency);
   begin
      Set_Interval (SPKR_PWM.Slice, Interval);
      Set_Duty_Cycle (SPKR_PWM.Slice, SPKR_PWM.Channel, Interval / 2);
      RP.Device.Timer.Delay_Milliseconds (Milliseconds);
      Set_Duty_Cycle (SPKR_PWM.Slice, SPKR_PWM.Channel, 0);
   end Beep;

end Macropad;
