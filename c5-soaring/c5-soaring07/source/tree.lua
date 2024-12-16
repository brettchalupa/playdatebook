function initTree()
	return {
		x = screenWidth + 40,
		y = 0,
		w = 40,
		h = 80,
		s = 4,
	}
end

function updateTree(tree)
	tree.x -= tree.s

	if tree.x < -tree.w then
		tree.x = screenWidth + math.random(tree.w + 10, tree.w + 40)
		tree.y = math.random(-20, screenHeight - 20)
	end
end

function treeHitbox(tree)
	return playdate.geometry.rect.new(tree.x, tree.y, tree.w, tree.h)
end
