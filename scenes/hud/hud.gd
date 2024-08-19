extends CanvasLayer

var score = 0
var time = 0

func set_score(new_score: int):
	score = new_score
	$scorelabel.text = 'Score: ' + str(score)

func add_score(new_score: int):
	score += new_score
	$scorelabel.text = 'Score: ' + str(score)

func set_time(new_time: int):
	time = new_time
	$timelabel.text = 'Time: ' + str(time)
