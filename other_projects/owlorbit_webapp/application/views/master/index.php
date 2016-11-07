<?php
	

	echo "<b>total count ".count($users)."</b>";
	echo "<ol>";
	foreach($users as $row){
		echo "<li>";
		echo "id: ".$row->id.'<br/>';
		echo "name: ".$row->first_name.' '.$row->last_name.' <br/>';
		echo "email: ".$row->email.'<br/>';
		echo "phone: ".$row->phone_number.'<br/>';		
		echo "email: ".$row->avatar_original.'<br/>';
		echo "created: ".$row->created.'<br/>';
		echo "------<br/><br/>";
		echo "</li>";
	}
	echo "</ol>";
?>