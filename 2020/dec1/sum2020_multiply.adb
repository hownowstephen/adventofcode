with Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
-- with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO;           use Ada.Integer_Text_IO;

procedure Sum2020_Multiply is

 -- Since our value will sum to 2020, we assume the values in the
   -- file will be less than 2020
   type SumNum is range 0 .. 2020;

   -- Not going to bother figuring out how to do this dynamically  
   type Index is range 0 .. 200;
   Numbers : array (Index) of SumNum;

   F : File_Type;
   I : Index := 0;

   Result : Integer := 0;

begin
   Ada.Text_IO.Put_Line ("Hello, December First"); 

   Open (F, Mode => In_File, Name => "input.txt");
   While not  End_Of_File (F) loop
      Numbers(I) := SumNum(Integer'Value (Get_Line (F)));
      I := I + 1;
   end loop;
   Close (F);

   For J in Numbers'Range loop
      For K in Numbers'Range loop
         if Numbers(J)+Numbers(K) = 2020 then
            Result := Integer(Numbers(J)*Numbers(K));
            exit;
         end if;
         exit when Result > 0;
      end loop;
   end loop;

   Put_Line("Result:" & Integer'Image(Integer(Result)));

end Sum2020_Multiply;
