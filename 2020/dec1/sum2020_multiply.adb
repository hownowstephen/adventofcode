with Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
-- with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO;           use Ada.Integer_Text_IO;

procedure Sum2020_Multiply is

   -- Not going to bother figuring out how to do this dynamically  
   type Index is range 0 .. 200;
   Numbers : array (Index) of Long_Integer;

   F : File_Type;
   I : Index := 0;

   Result : Long_Integer := 0;

begin
   Ada.Text_IO.Put_Line ("Hello, December First"); 

   Open (F, Mode => In_File, Name => "input.txt");
   While not  End_Of_File (F) loop
      Numbers(I) := Long_Integer(Integer'Value (Get_Line (F)));
      I := I + 1;
   end loop;
   Close (F);

   For J in Numbers'Range loop
      For K in Numbers'Range loop
         if Numbers(J)+Numbers(K) < 2020 then
            For L in Numbers'Range loop
               if Numbers(J)+Numbers(K)+Numbers(L) = 2020 then
                  Result := Numbers(J)*Numbers(K) * Numbers(L);
                  exit;
               end if;
            end loop;
         end if;
         exit when Result > 0;
      end loop;
      exit when Result > 0;
   end loop;

   Put_Line("Result:" & Integer'Image(Integer(Result)));

end Sum2020_Multiply;
