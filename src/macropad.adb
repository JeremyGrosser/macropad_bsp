--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with RP.DMA;

package body Macropad is
   PWM_Frequency : constant Hertz := 10_000_000;

   procedure Initialize is
   begin
      RP.Clock.Initialize (XOSC_Frequency, XOSC_Startup_Delay);
      Delays.Enable;
      RP.DMA.Enable;
      Neopixel.PIO.Enable;

      Neopixel.Initialize;
      Neopixel.Clear;
      Neopixel.Update (Blocking => True);

      SPKR_SD.Configure (Output, Floating);
      SPKR_SD.Clear;
      SPEAKER.Configure (Output, Floating, RP.GPIO.PWM);

      RP.PWM.Initialize;
      Set_Mode (SPKR_PWM.Slice, Free_Running);
      Set_Frequency (SPKR_PWM.Slice, PWM_Frequency);
      Set_Duty_Cycle (SPKR_PWM.Slice, SPKR_PWM.Channel, 16);
      Enable (SPKR_PWM.Slice);

      for K in GP'Range loop
         GP (K) := (Pin => GPIO_Pin (K));
         GP (K).Configure (Input, Pull_Up);
      end loop;

      --  OLED_RST.Configure (Output, Pull_Up);
      --  OLED_RST.Clear;
      --  OLED_DC.Configure (Output, Pull_Up);
      --  OLED_CS.Configure (Output, Pull_Up, RP.GPIO.SPI);
      --  SCK.Configure (Output, Pull_Up, RP.GPIO.SPI);
      --  MOSI.Configure (Output, Floating, RP.GPIO.SPI);
      --  MISO.Configure (Output, Floating, RP.GPIO.SPI);
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

   procedure Note_On
      (Frequency : Hertz := 200)
   is
   begin
      Set_Interval (SPKR_PWM.Slice, Period (PWM_Frequency / Frequency));
      SPKR_SD.Set;
   end Note_On;

   procedure Note_Off is
   begin
      SPKR_SD.Clear;
   end Note_Off;

   function Status
      return Key_States
   is
      State : Key_States;
   begin
      for K in State'Range loop
         if GP (K).Get then
            State (K) := Up;
         else
            State (K) := Down;
         end if;
      end loop;
      return State;
   end Status;

end Macropad;
