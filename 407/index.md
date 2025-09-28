Title: Fractional pixel margin rounding issue
Author: campaul
Created: Mon, 02 Jun 2025 17:44:27 +0000
State: open

Margins are rounded to a pixel value *before* being added resulting in margins sometimes being 1 pixel too wide. For example, if two adjacent elements both have margins of `2.5px`, those margins will get rounded to 3 resulting in a total space of 6 pixels between the elements. The correct behavior is to add them before rounding which would result in a total space of 5 pixels.