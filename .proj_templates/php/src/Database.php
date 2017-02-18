<?php
class Database
{
	private $instance;

	public function __construct($host, $user, $pass, $db) {
		$this->instance = new mysqli($host, $user, $pass, $db);

		if ($this->instance->connect_errno) {
			echo "Failed to connect to database $db." . $mysqli->connect_error;
    		exit();
		}
	}

	public function close() {
		$this->instance->close();
	}

	public function query($sql) {
		return $this->instance->query($sql);
	}

	public function getRow($sql) {
		$result = $this->query($sql);

		if ($result && $result->num_rows == 1) {
			return $result->fetch_array(MYSQLI_ASSOC);
		}
	}

	public function getRows($sql) {
		$result = $this->query($sql);

		if ($result && $result->num_rows > 0) {
			for ($set = array(); $row = $result->fetch_array(MYSQLI_ASSOC); array_push($set, $row));
			return $set;
		}
	}
}