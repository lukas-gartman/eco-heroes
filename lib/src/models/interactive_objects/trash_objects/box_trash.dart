import '../../enums/trash_type.dart';
import '../trash.dart';

class BoxTrash extends Trash {
  BoxTrash({required super.position})
    : super(trashType: TrashType.paper, spriteSrc: 'trash_objects/box.png');
}