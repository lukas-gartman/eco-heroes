import '../../enums/trash_type.dart';
import '../trash.dart';

class MilkTrash extends Trash {
  MilkTrash({required super.position})
    : super(trashType: TrashType.paper, spriteSrc: 'trash_objects/milk.png');
}