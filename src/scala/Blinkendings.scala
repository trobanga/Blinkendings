/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

//package Blinkendings

import spinal.core._
import spinal.lib._

class Blinkendings extends Component {
  val io = new Bundle {

    val CLOCK_50_B5B = in Bool
      val CLOCK_50_B6A = in Bool
      val CLOCK_50_B7A = in Bool
      val CLOCK_50_B8A = in Bool
      val CLOCK_125_p = in Bool
      val CPU_RESET_n = in Bool

      val KEY = in UInt(4 bits)


      val LEDG = out UInt(8 bits)
      val LEDR = out UInt(10 bits)


  }


    io.LEDG := 14
    io.LEDR := 27

}

object Blinkendings {
  def main(args: Array[String]) {
    SpinalVhdl(new Blinkendings)
    //SpinalVerilog(new MyTopLevel)
  }
}

