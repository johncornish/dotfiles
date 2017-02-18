<?php
class Template
{
	private $parts = array();
	private $keys = array();

	function __construct($templ_file)
	{
		$tmp_str = file_get_contents($templ_file);
		$tmp_arr = explode('{{', $tmp_str);

		foreach ($tmp_arr as $t) {
			$tmp_arr2 = explode('}}', $t);
			if (count($tmp_arr2) == 2) {
				array_push($this->keys, $tmp_arr2[0]);
				array_push($this->parts, $tmp_arr2[1]);
			} else if (count($tmp_arr2) == 1) {
				array_push($this->parts, $tmp_arr2[0]);
			}
		}
	}

	public function weave($assoc)
	{
		$ret = '';
		for ($i = 0; $i < count($this->keys); $i++) { 
			$ret .= $this->parts[$i];
			if (array_key_exists($this->keys[$i], $assoc)) {
				$ret .= $assoc[$this->keys[$i]];
			} else {
				$ret .= '';
			}
		}
		$ret .= end($this->parts);

		return $ret;
	}

	public function render($array)
	{
		$ret = '';
		$i = 0;
		foreach ($array as $assoc) {
			$assoc['i'] = $i++;
			$ret .= $this->weave($assoc);
		}
		return $ret;
	}
}